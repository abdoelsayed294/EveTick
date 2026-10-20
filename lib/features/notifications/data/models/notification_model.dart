import 'package:evetick/features/notifications/data/models/notification_type.dart';

/// One notification: `users/{uid}/notifications/{notificationId}`.
///
/// {
///   type, title, body, isRead, createdAt, eventId?
/// }
///
/// Written by the server (Cloud Function). The app only reads them and flips
/// `isRead`.
class AppNotification {
  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.isRead,
    this.eventId,
    this.createdAt,
  });

  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final bool isRead;

  /// When set, tapping the notification opens this event.
  final String? eventId;
  final DateTime? createdAt;

  /// Seen in the last 24 hours: shown above the "EARLIER" header.
  bool isRecent(DateTime now) {
    final date = createdAt;
    if (date == null) return true; // server timestamp still pending
    return now.difference(date).inHours < 24;
  }

  /// [json] is the document data plus `id` and a `createdAt` that is already
  /// a [DateTime] (null while the server timestamp is pending).
  factory AppNotification.fromJson(Map<String, dynamic> json) {
    final type = NotificationType.fromValue(json['type'] as String?);
    final title = (json['title'] as String?)?.trim() ?? '';
    final eventId = (json['eventId'] as String?)?.trim();

    return AppNotification(
      id: json['id'] as String,
      type: type,
      title: title.isEmpty ? _defaultTitle(type) : title,
      body: (json['body'] as String?)?.trim() ?? '',
      isRead: json['isRead'] as bool? ?? false,
      eventId: (eventId == null || eventId.isEmpty) ? null : eventId,
      createdAt: json['createdAt'] as DateTime?,
    );
  }

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      type: type,
      title: title,
      body: body,
      isRead: isRead ?? this.isRead,
      eventId: eventId,
      createdAt: createdAt,
    );
  }

  static String _defaultTitle(NotificationType type) {
    switch (type) {
      case NotificationType.hotDeal:
        return 'Hot Deal';
      case NotificationType.newEvent:
        return 'New Event Near You!';
      case NotificationType.ticketConfirmed:
        return 'Ticket Confirmed';
      case NotificationType.profileUpdated:
        return 'Profile Updated';
      case NotificationType.artistFollowed:
        return 'Artist You Follow';
      case NotificationType.general:
        return 'Notification';
    }
  }
}
