import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:evetick/core/config/paymob_config.dart';
import 'package:evetick/core/helpers/sales_day_key.dart';
import 'package:evetick/core/helpers/section_resolver.dart';
import 'package:evetick/core/services/firebase_error_handler.dart';
import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/event_booking/data/data_sources/remote/event_booking_data_source.dart';
import 'package:evetick/features/event_booking/data/models/event_model.dart';
import 'package:evetick/features/event_booking/data/models/order_model.dart';
import 'package:evetick/features/event_booking/data/models/payment_session.dart';
import 'package:evetick/features/event_booking/data/models/seating_config_model.dart';
import 'package:evetick/features/event_booking/data/models/ticket_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:evetick/core/services/firebase_failure.dart';
import 'package:evetick/features/event_booking/data/data_sources/remote/booking_exception.dart';
import 'package:evetick/features/event_booking/data/models/ticket_tier_model.dart';

class EventBookingDataSourceImpl extends EventBookingDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 20),
    receiveTimeout: const Duration(seconds: 30),
    contentType: Headers.jsonContentType,
  ));

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
      if (seatingConfig == null) return SeatingConfig.general();
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

      final userDoc = await firestore.collection('users').doc(user.uid).get();
      final savedName = (userDoc.data()?['name'] as String?)?.trim();
      final attendeeName = (savedName != null && savedName.isNotEmpty)
          ? savedName
          : (user.displayName ?? user.email);

      final eventRef = firestore.collection('events').doc(order.eventId);
      final orderRef = firestore.collection('orders').doc();

      await firestore.runTransaction((tx) async {
        final snap = await tx.get(eventRef);
        if (!snap.exists) throw BookingException('Event not found');
        final data = snap.data()!;

        final tiers = (data['ticketTiers'] as List<dynamic>? ?? [])
            .map((t) => Map<String, dynamic>.from(t as Map))
            .toList();

        double serverSubtotal = 0;
        for (final item in order.tickets) {
          final tier = tiers[item.tierIndex];
          final stock = (tier['ticketQuantity'] as num).toInt();
          if (stock < item.quantity) {
            throw BookingException('${item.name} tickets are not available anymore');
          }
          serverSubtotal += (tier['ticketPrice'] as num).toDouble() * item.quantity;
          tier['ticketQuantity'] = stock - item.quantity;
        }
        if ((serverSubtotal - order.subtotal).abs() > 0.01) {
          throw BookingException('Ticket prices changed, please try again');
        }

        final rawConfig = data['seatingConfig'];
        final config = rawConfig == null
            ? SeatingConfig.general()
            : SeatingConfig.fromJson(Map<String, dynamic>.from(rawConfig as Map));

        final updates = <String, dynamic>{
          'ticketTiers': tiers,
          'ticketsSold': FieldValue.increment(order.ticketCount),
          'salesByDay.${salesDayKey(DateTime.now())}':
              FieldValue.increment(order.ticketCount),
        };
        final sectionByTier = <int, String>{};

        if (config.isSeated) {
          if (order.seats.length != order.ticketCount) {
            throw BookingException('Please select a seat for every ticket');
          }

          final seatingConfig = Map<String, dynamic>.from(rawConfig as Map);
          final seatMap = (seatingConfig['seatMap'] as List<dynamic>)
              .map((r) => Map<String, dynamic>.from(r as Map))
              .toList();

          for (final seat in order.seats) {
            final seats =
                List<dynamic>.from(seatMap[seat.rowIndex]['seats'] as List);
            if (seats[seat.seatIndex] != 'available') {
              throw BookingException(
                'Seat ${seat.label} was just taken, please choose another one',
              );
            }
            seats[seat.seatIndex] = 'reserved';
            seatMap[seat.rowIndex]['seats'] = seats;
          }
          seatingConfig['seatMap'] = seatMap;
          updates['seatingConfig'] = seatingConfig;
        } else {
          if (order.seats.isNotEmpty) {
            throw BookingException('This event has no seat selection');
          }
          for (final item in order.tickets) {
            final section = resolveSectionName(
              ticketName: tiers[item.tierIndex]['ticketName'] as String? ?? item.name,
              tierIndex: item.tierIndex,
              tiersCount: tiers.length,
              sectionNames: config.sectionNames,
            );
            if (section != null) sectionByTier[item.tierIndex] = section;
          }
        }

        tx.update(eventRef, updates);
        tx.set(orderRef, {
          ...order.toMap(
            orderId: orderRef.id,
            userId: user.uid,
            attendeeName: attendeeName,
            sectionByTier: sectionByTier,
          ),
          'createdAt': FieldValue.serverTimestamp(),
        });
      });

      return Result.success(orderRef.id);
    } on BookingException catch (e) {
      return Result.failure(FirebaseErrorHandler.notFound(e.message));
    } on FirebaseException catch (e) {
      return Result.failure(FirebaseErrorHandler.handleFirestore(e));
    } catch (e) {
      return Result.failure(FirebaseErrorHandler.handleGeneric(e));
    }
  }

  @override
  Future<Result<PaymentSession>> createPayment(OrderModel order) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        return Result.failure(FirebaseFailure('Please login to continue'));
      }
      final token = await user.getIdToken();

      final response = await _dio.post<Map<String, dynamic>>(
        PaymobConfig.createPaymentUrl,
        data: order.toPaymentRequest(),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return Result.success(PaymentSession.fromJson(response.data!));
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map ? data['message'] as String? : null;
      return Result.failure(FirebaseFailure(
        message ?? 'Could not start the payment, please try again',
      ));
    } catch (e) {
      return Result.failure(FirebaseErrorHandler.handleGeneric(e));
    }
  }

  @override
  Stream<String> watchOrderStatus(String orderId) {
    return firestore
        .collection('orders')
        .doc(orderId)
        .snapshots()
        .map((doc) => doc.data()?['status'] as String? ?? 'pending');
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
    } on BookingException catch (e) {
      return Result.failure(FirebaseErrorHandler.notFound(e.message));
    } on FirebaseException catch (e) {
      return Result.failure(FirebaseErrorHandler.handleFirestore(e));
    } catch (e) {
      return Result.failure(FirebaseErrorHandler.handleGeneric(e));
    }
  }
}
