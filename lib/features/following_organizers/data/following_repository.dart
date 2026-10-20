import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evetick/core/services/failure.dart';
import 'package:evetick/core/services/firebase_error_handler.dart';
import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/following_organizers/data/models/followed_organizer_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Who the signed-in user follows: `users/{me}/following/{organizerId}`.
/// The `followers` counter on the organizer's own document is kept by the
/// `onFollowCreated` / `onFollowDeleted` Cloud Functions, never by the app.
class FollowingRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  /// Null when signed out, or when the organizer is the user's own account.
  DocumentReference<Map<String, dynamic>>? _followRef(String organizerId) {
    final uid = auth.currentUser?.uid;
    if (uid == null || uid == organizerId) return null;
    return firestore
        .collection('users')
        .doc(uid)
        .collection('following')
        .doc(organizerId);
  }

  /// False for guests and for the user's own organizer account.
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

  /// Follows / unfollows. Returns false if saving failed.
  Future<bool> setFollowing(String organizerId, {required bool follow}) async {
    try {
      final ref = _followRef(organizerId);
      if (ref == null) return false;
      if (follow) {
        await ref.set({'createdAt': FieldValue.serverTimestamp()});
      } else {
        await ref.delete();
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Organizers the user follows, the most recently followed first.
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

      // Newest first (sorted here: no index needed).
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
            // One broken account must not break the whole list.
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
