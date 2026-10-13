import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evetick/core/services/firebase_error_handler.dart';
import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/event_details/data/models/event_details_model.dart';
import 'package:evetick/features/location/data/models/location_model.dart';
import 'package:geocoding/geocoding.dart';

class EventDetailsRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Result<EventDetails>> getEventDetails(String eventId) async {
    try {
      final doc = await firestore.collection('events').doc(eventId).get();
      if (!doc.exists) {
        return Result.failure(FirebaseErrorHandler.notFound('Event not found'));
      }
      return Result.success(EventDetails.fromJson(doc.data()!));
    } on FirebaseException catch (e) {
      return Result.failure(FirebaseErrorHandler.handleFirestore(e));
    } catch (e) {
      return Result.failure(FirebaseErrorHandler.handleGeneric(e));
    }
  }

  
  Future<LocationModel?> findCoordinates(String address) async {
    try {
      final results = await locationFromAddress(address);
      if (results.isEmpty) return null;
      return LocationModel(
        latitude: results.first.latitude,
        longitude: results.first.longitude,
        address: address,
      );
    } catch (_) {
      return null;
    }
  }
}
