import 'package:evetick/features/notifications/data/models/notification_model.dart';

enum NotificationFilter {
  all,
  events,
  tickets;

  bool matches(AppNotification notification) {
    switch (this) {
      case NotificationFilter.all:
        return true;
      case NotificationFilter.events:
        return notification.type.isEvent;
      case NotificationFilter.tickets:
        return notification.type.isTicket;
    }
  }
}
