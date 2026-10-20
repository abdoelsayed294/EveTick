import 'package:evetick/core/routing/routes.dart';
import 'package:evetick/features/notifications/data/models/notification_model.dart';
import 'package:evetick/features/notifications/logic/notifications_cubit/notifications_cubit.dart';
import 'package:evetick/core/helpers/notification_time_label.dart';
import 'package:evetick/features/notifications/ui/widgets/notification_card.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A [NotificationCard] with the spacing under it, its time label, and the
/// tap behaviour (remove the dot, open the event if there is one).
class NotificationListItem extends StatelessWidget {
  const NotificationListItem({
    super.key,
    required this.notification,
    required this.now,
  });

  final AppNotification notification;
  final DateTime now;

  void _open(BuildContext context) {
    context.read<NotificationsCubit>().markAsRead(notification.id);
    final eventId = notification.eventId;
    if (eventId != null) {
      Navigator.of(context)
          .pushNamed(Routes.eventDetailsScreen, arguments: eventId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: NotificationCard(
        notification: notification,
        timeLabel: notificationTimeLabel(
          l10n,
          notification.createdAt,
          now: now,
        ),
        onTap: () => _open(context),
      ),
    );
  }
}
