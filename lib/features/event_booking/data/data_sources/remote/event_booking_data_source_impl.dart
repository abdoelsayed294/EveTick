import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evetick/core/services/failure.dart';
import 'package:evetick/core/services/firebase_error_handler.dart';
import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/event_booking/data/data_sources/remote/event_booking_data_source.dart';
import 'package:evetick/features/event_booking/data/models/event_model.dart';
import 'package:evetick/features/event_booking/data/models/order_model.dart';
import 'package:evetick/features/event_booking/data/models/seating_config_model.dart';
import 'package:evetick/features/event_booking/data/models/ticket_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventBookingDataSourceImpl extends EventBookingDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Future<Result<EventModel>> getEvent(String eventId) {
    return _fetchFromEvent(
      eventId,
      (data) => EventModel.fromJson(data),
    );
  }

  @override
  Future<Result<List<TicketTier>>> getTicketTier(String eventId) {
    return _fetchFromEvent(eventId, (data) {
      final ticketTiersData = data['ticketTiers'] as List<dynamic>? ?? [];
      return ticketTiersData
          .map((t) => TicketTier.fromJson(Map<String, dynamic>.from(t as Map)))
          .toList();
    });
  }

  @override
  Future<Result<SeatingConfig>> getSeatingConfig(String eventId) {
    return _fetchFromEvent(eventId, (data) {
      final seatingConfig = data['seatingConfig'];
      if (seatingConfig == null) {
        throw _BookingException('This event has no seating map');
      }
      return SeatingConfig.fromJson(
        Map<String, dynamic>.from(seatingConfig as Map),
      );
    });
  }

  @override
  Future<Result<String>> placeOrder(OrderModel order) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        return Result.failure(FirebaseFailure('Please login to continue'));
      }

      // Attendee name printed on the ticket (users/{uid}.name).
      final userDoc = await firestore.collection('users').doc(user.uid).get();
      final savedName = (userDoc.data()?['name'] as String?)?.trim();
      final attendeeName = (savedName != null && savedName.isNotEmpty)
          ? savedName
          : (user.displayName ?? user.email);

      final eventRef = firestore.collection('events').doc(order.eventId);
      final orderRef = firestore.collection('orders').doc();

      await firestore.runTransaction((tx) async {
        final snap = await tx.get(eventRef);
        if (!snap.exists) throw _BookingException('Event not found');
        final data = snap.data()!;

        // ---- ticket stock + price check
        final tiers = (data['ticketTiers'] as List<dynamic>? ?? [])
            .map((t) => Map<String, dynamic>.from(t as Map))
            .toList();

        double serverSubtotal = 0;
        for (final item in order.tickets) {
          final tier = tiers[item.tierIndex];
          final stock = (tier['ticketQuantity'] as num).toInt();
          if (stock < item.quantity) {
            throw _BookingException('${item.name} tickets are not available anymore');
          }
          serverSubtotal += (tier['ticketPrice'] as num).toDouble() * item.quantity;
          tier['ticketQuantity'] = stock - item.quantity;
        }
        if ((serverSubtotal - order.subtotal).abs() > 0.01) {
          throw _BookingException('Ticket prices changed, please try again');
        }

        // ---- seats
        final seatingConfig = Map<String, dynamic>.from(data['seatingConfig'] as Map);
        final seatMap = (seatingConfig['seatMap'] as List<dynamic>)
            .map((r) => Map<String, dynamic>.from(r as Map))
            .toList();

        for (final seat in order.seats) {
          final seats = List<dynamic>.from(seatMap[seat.rowIndex]['seats'] as List);
          if (seats[seat.seatIndex] != 'available') {
            throw _BookingException(
              'Seat ${seat.label} was just taken, please choose another one',
            );
          }
          seats[seat.seatIndex] = 'reserved';
          seatMap[seat.rowIndex]['seats'] = seats;
        }
        seatingConfig['seatMap'] = seatMap;

        tx.update(eventRef, {
          'ticketTiers': tiers,
          'seatingConfig': seatingConfig,
        });
        tx.set(orderRef, {
          ...order.toMap(
            orderId: orderRef.id,
            userId: user.uid,
            attendeeName: attendeeName,
          ),
          'createdAt': FieldValue.serverTimestamp(),
        });
      });

      return Result.success(orderRef.id);
    } on _BookingException catch (e) {
      return Result.failure(FirebaseErrorHandler.notFound(e.message));
    } on FirebaseException catch (e) {
      return Result.failure(FirebaseErrorHandler.handleFirestore(e));
    } catch (e) {
      return Result.failure(FirebaseErrorHandler.handleGeneric(e));
    }
  }

  @override
  Future<Result<TicketModel>> getOrder(String orderId) async {
    try {
      final doc = await firestore.collection('orders').doc(orderId).get();
      if (!doc.exists) {
        return Result.failure(FirebaseErrorHandler.notFound('Ticket not found'));
      }
      return Result.success(TicketModel.fromJson(doc.data()!));
    } on FirebaseException catch (e) {
      return Result.failure(FirebaseErrorHandler.handleFirestore(e));
    } catch (e) {
      return Result.failure(FirebaseErrorHandler.handleGeneric(e));
    }
  }

  /// Reads `events/{eventId}` once and parses it with [parse],
  /// converting every failure into a [Result.failure].
  Future<Result<T>> _fetchFromEvent<T>(
    String eventId,
    T Function(Map<String, dynamic> data) parse,
  ) async {
    try {
      final eventDoc = await firestore.collection('events').doc(eventId).get();
      if (!eventDoc.exists) {
        return Result.failure(FirebaseErrorHandler.notFound('Event not found'));
      }
      return Result.success(parse(eventDoc.data()!));
    } on _BookingException catch (e) {
      return Result.failure(FirebaseErrorHandler.notFound(e.message));
    } on FirebaseException catch (e) {
      return Result.failure(FirebaseErrorHandler.handleFirestore(e));
    } catch (e) {
      return Result.failure(FirebaseErrorHandler.handleGeneric(e));
    }
  }
}

class _BookingException implements Exception {
  _BookingException(this.message);
  final String message;
}
