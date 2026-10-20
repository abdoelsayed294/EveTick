import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evetick/core/services/firebase_error_handler.dart';
import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/home/data/models/home_event_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:evetick/core/services/firebase_failure.dart';

class FavoritesRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  static const int _chunkSize = 10;

  Future<Result<List<HomeEvent>>> getFavoriteEvents() async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        return Result.failure(FirebaseFailure('Please login to see your favorites'));
      }

      final userDoc = await firestore.collection('users').doc(user.uid).get();
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
          }
        }
      }

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
