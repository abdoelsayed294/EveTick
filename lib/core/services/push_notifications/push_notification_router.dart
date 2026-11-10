import 'package:evetick/core/di/dependency_injection.dart';
import 'package:evetick/core/routing/app_navigator.dart';
import 'package:evetick/core/routing/routes.dart';
import 'package:evetick/features/notifications/data/notifications_repository.dart';

class PushNotificationRouter {
  static Future<void> open(Map<String, dynamic> data) async {
    final notificationId = data['notificationId'] as String?;
    if (notificationId != null && notificationId.isNotEmpty) {
      await getIt<NotificationsRepository>().markAsRead(notificationId);
    }

    final navigator = appNavigatorKey.currentState;
    if (navigator == null) return;

    navigator.pushNamed(Routes.notificationsScreen);

    final eventId = data['eventId'] as String?;
    if (eventId != null && eventId.isNotEmpty) {
      navigator.pushNamed(Routes.eventDetailsScreen, arguments: eventId);
    }
  }
}
