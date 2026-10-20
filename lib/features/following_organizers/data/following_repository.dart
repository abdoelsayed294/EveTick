import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evetick/core/services/firebase_error_handler.dart';
import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/following_organizers/data/models/followed_organizer_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:evetick/core/services/firebase_failure.dart';

class FollowingRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

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

  Future<Result<List<FollowedOrganizer>>> getFollowedOrganizers() async {
    try {
      final uid = auth.currentUser?.uid;
      if (uid == null) {
        return Result.failure(
          FirebaseFailure('Please login to see the organizers you follow'),
        );
      }

      final snapshot = await firestore
          .collection('users')
          .doc(uid)
          .collection('following')
          .get();

      final docs = snapshot.docs.toList()
        ..sort((a, b) {
          final aTime = (a.data()['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
          final bTime = (b.data()['createdAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
          return bTime.compareTo(aTime);
        });

      final organizers = await Future.wait(
        docs.map((doc) async {
          try {
            final user = await firestore.collection('users').doc(doc.id).get();
            final data = user.data();
            if (data == null) return null;
            return FollowedOrganizer.fromUser(doc.id, data);
          } catch (_) {
            return null;
          }
        }),
      );

      return Result.success(organizers.whereType<FollowedOrganizer>().toList());
    } on FirebaseException catch (e) {
      return Result.failure(FirebaseErrorHandler.handleFirestore(e));
    } catch (e) {
      return Result.failure(FirebaseErrorHandler.handleGeneric(e));
    }
  }
}
