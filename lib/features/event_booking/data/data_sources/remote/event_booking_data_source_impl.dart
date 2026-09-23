import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evetick/core/services/firebase_error_handler.dart';
import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/event_booking/data/data_sources/remote/event_booking_data_source.dart';
import 'package:evetick/features/event_booking/data/models/event_model.dart';

class EventBookingDataSourceImpl extends EventBookingDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<Result<List<TicketTier>>> getTicketTier(String eventId) async {
    try {
      final eventDoc = await firestore.collection('events').doc(eventId).get();
      if (!eventDoc.exists) {
        return Result.failure(FirebaseErrorHandler.notFound('Event not found'));
      }
      final data = eventDoc.data()!;
      final ticketTiersData = data['ticketTiers'] as List<dynamic>;
      final ticketTiers = ticketTiersData
          .map((ticket) => TicketTier.fromJson(ticket as Map<String, dynamic>))
          .toList();

      return Result.success(ticketTiers);
    } on FirebaseException catch (e) {
      return Result.failure(FirebaseErrorHandler.handleFirestore(e));
    } catch (e) {
      return Result.failure(FirebaseErrorHandler.handleGeneric(e));
    }
  }
}
