import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evetick/core/services/failure.dart';
import 'package:evetick/core/services/firebase_error_handler.dart';
import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/home/data/data_sources/home_data_source.dart';
import 'package:evetick/features/home/data/models/home_event_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeDataSourceImpl extends HomeDataSource {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Future<Result<List<HomeEvent>>> getLiveEvents() async {
    try {
      final snapshot = await firestore
          .collection('events')
          .where('status', isEqualTo: 'live')
          .get();

      final events = <HomeEvent>[];
      for (final doc in snapshot.docs) {
        try {
          events.add(HomeEvent.fromJson({'eventId': doc.id, ...doc.data()}));
        } catch (_) {
          // A malformed event document must not break the whole home screen.
        }
      }
      return Result.success(events);
    } on FirebaseException catch (e) {
      return Result.failure(FirebaseErrorHandler.handleFirestore(e));
    } catch (e) {
      return Result.failure(FirebaseErrorHandler.handleGeneric(e));
    }
  }

  /// Favorites live on the user's own document: users/{uid}.favoriteEventIds
  @override
  Future<Result<Set<String>>> getFavoriteIds() async {
    try {
      final user = auth.currentUser;
      if (user == null) return Result.success(<String>{});

      final doc = await firestore.collection('users').doc(user.uid).get();
      final ids = (doc.data()?['favoriteEventIds'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toSet();
      return Result.success(ids);
    } on FirebaseException catch (e) {
      return Result.failure(FirebaseErrorHandler.handleFirestore(e));
    } catch (e) {
      return Result.failure(FirebaseErrorHandler.handleGeneric(e));
    }
  }

  @override
  Future<Result<void>> setFavorite(
    String eventId, {
    required bool isFavorite,
  }) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        return Result.failure(FirebaseFailure('Please login to continue'));
      }

      await firestore.collection('users').doc(user.uid).update({
        'favoriteEventIds': isFavorite
            ? FieldValue.arrayUnion([eventId])
            : FieldValue.arrayRemove([eventId]),
      });
      return Result.success(null);
    } on FirebaseException catch (e) {
      return Result.failure(FirebaseErrorHandler.handleFirestore(e));
    } catch (e) {
      return Result.failure(FirebaseErrorHandler.handleGeneric(e));
    }
  }
}
