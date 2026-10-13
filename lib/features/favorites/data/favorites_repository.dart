import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evetick/core/services/failure.dart';
import 'package:evetick/core/services/firebase_error_handler.dart';
import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/home/data/models/home_event_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Reads the events the user hearted (`users/{uid}.favoriteEventIds`).
/// Adding / removing a favorite is done by `HomeRepo.setFavorite`.
class FavoritesRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  /// Firestore `whereIn` accepts a limited number of values per query.
  static const int _chunkSize = 10;

  /// Favorite events, the most recently added first.
  Future<Result<List<HomeEvent>>> getFavoriteEvents() async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        return Result.failure(FirebaseFailure('Please login to see your favorites'));
      }

      final userDoc = await firestore.collection('users').doc(user.uid).get();
      // arrayUnion appends, so the newest favorite is last.
      final ids = (userDoc.data()?['favoriteEventIds'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList()
          .reversed
          .toList();
      if (ids.isEmpty) return Result.success(<HomeEvent>[]);

      final byId = <String, HomeEvent>{};
      for (var i = 0; i < ids.length; i += _chunkSize) {
        final chunk = ids.sublist(
          i,
          i + _chunkSize > ids.length ? ids.length : i + _chunkSize,
        );
        final snapshot = await firestore
            .collection('events')
            .where(FieldPath.documentId, whereIn: chunk)
            .get();
        for (final doc in snapshot.docs) {
          try {
            byId[doc.id] = HomeEvent.fromJson({'eventId': doc.id, ...doc.data()});
          } catch (_) {
            // A malformed event must not break the whole list.
          }
        }
      }

      // Keep the saved order; events deleted since then are skipped.
      return Result.success([
        for (final id in ids)
          if (byId.containsKey(id)) byId[id]!,
      ]);
    } on FirebaseException catch (e) {
      return Result.failure(FirebaseErrorHandler.handleFirestore(e));
    } catch (e) {
      return Result.failure(FirebaseErrorHandler.handleGeneric(e));
    }
  }
}
