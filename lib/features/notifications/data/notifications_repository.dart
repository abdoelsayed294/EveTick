import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evetick/core/services/failure.dart';
import 'package:evetick/core/services/firebase_error_handler.dart';
import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/notifications/data/models/notification_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Notifications live in `users/{uid}/notifications/{notificationId}`.
/// They are created by the server; the app reads the latest ones and marks
/// them as read.
class NotificationsRepository {
  static const int limit = 50;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> _notifications(String uid) =>
      firestore.collection('users').doc(uid).collection('notifications');

  /// The latest [limit] notifications, newest first.
  Future<Result<List<AppNotification>>> getNotifications() async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        return Result.failure(
          FirebaseFailure('Please login to see your notifications'),
        );
      }

      final snapshot = await _notifications(user.uid)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      final notifications = <AppNotification>[];
      for (final doc in snapshot.docs) {
        try {
          final data = doc.data();
          notifications.add(
            AppNotification.fromJson({
              ...data,
              'id': doc.id,
              'createdAt': (data['createdAt'] as Timestamp?)?.toDate(),
            }),
          );
        } catch (_) {
          // A malformed notification must not break the whole list.
        }
      }
      return Result.success(notifications);
    } on FirebaseException catch (e) {
      return Result.failure(FirebaseErrorHandler.handleFirestore(e));
    } catch (e) {
      return Result.failure(FirebaseErrorHandler.handleGeneric(e));
    }
  }

  Future<Result<void>> markAsRead(String notificationId) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        return Result.failure(FirebaseFailure('Please login to continue'));
      }
      await _notifications(user.uid)
          .doc(notificationId)
          .update({'isRead': true});
      return Result.success(null);
    } on FirebaseException catch (e) {
      return Result.failure(FirebaseErrorHandler.handleFirestore(e));
    } catch (e) {
      return Result.failure(FirebaseErrorHandler.handleGeneric(e));
    }
  }
}
