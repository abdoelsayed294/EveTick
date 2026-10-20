import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evetick/core/services/firebase_error_handler.dart';
import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/event_details/data/models/event_details_model.dart';
import 'package:evetick/features/event_details/data/models/event_organizer_model.dart';
import 'package:evetick/features/location/data/models/location_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:evetick/core/services/firebase_failure.dart';

class EventDetailsRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<Result<EventDetails>> getEventDetails(String eventId) async {
    try {
      final doc = await firestore.collection('events').doc(eventId).get();
      if (!doc.exists) {
        return Result.failure(FirebaseErrorHandler.notFound('Event not found'));
      }
      final event = EventDetails.fromJson(doc.data()!);
      return Result.success(await _withOrganizer(event));
    } on FirebaseException catch (e) {
      return Result.failure(FirebaseErrorHandler.handleFirestore(e));
    } catch (e) {
      return Result.failure(FirebaseErrorHandler.handleGeneric(e));
    }
  }

  Future<EventDetails> _withOrganizer(EventDetails event) async {
    final id = event.organizerId;
    if (event.organizer != null || id == null || id.isEmpty) return event;
    try {
      final doc = await firestore.collection('users').doc(id).get();
      final data = doc.data();
      if (data == null) return event;
      return event.withOrganizer(EventOrganizer.fromUser(data));
    } catch (_) {
      return event;
    }
  }

  Future<EventDetails> refreshOrganizer(EventDetails event) async {
    final id = event.organizerId;
    if (id == null || id.isEmpty) return event;
    try {
      final doc = await firestore.collection('users').doc(id).get();
      final data = doc.data();
      if (data == null) return event;
      final organizer = EventOrganizer.fromUser(data);
      return organizer == null ? event : event.withOrganizer(organizer);
    } catch (_) {
      return event;
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

  DocumentReference<Map<String, dynamic>>? _followRef(String organizerId) {
    final uid = auth.currentUser?.uid;
    if (uid == null || uid == organizerId) return null;
    return firestore
        .collection('users')
        .doc(uid)
        .collection('following')
        .doc(organizerId);
  }

  bool canFollow(String organizerId) => _followRef(organizerId) != null;

  Future<bool> isFollowing(String organizerId) async {
    try {
      final ref = _followRef(organizerId);
      if (ref == null) return false;
      return (await ref.get()).exists;
    } catch (_) {
      return false;
    }
  }

  Future<Result<void>> setFollowing(
    String organizerId, {
    required bool follow,
  }) async {
    try {
      final ref = _followRef(organizerId);
      if (ref == null) {
        return Result.failure(FirebaseFailure('Please login to continue'));
      }
      if (follow) {
        await ref.set({'createdAt': FieldValue.serverTimestamp()});
      } else {
        await ref.delete();
      }
      return Result.success(null);
    } on FirebaseException catch (e) {
      return Result.failure(FirebaseErrorHandler.handleFirestore(e));
    } catch (e) {
      return Result.failure(FirebaseErrorHandler.handleGeneric(e));
    }
  }
}
