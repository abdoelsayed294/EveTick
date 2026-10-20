import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/features/notifications/data/models/notification_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// The coloured square icon at the start of a notification card.
class NotificationTypeIcon extends StatelessWidget {
  const NotificationTypeIcon({super.key, required this.type});

  final NotificationType type;

  ({IconData icon, Color color, Color background}) get _style {
    switch (type) {
      case NotificationType.hotDeal:
        return (
          icon: Icons.local_fire_department_rounded,
          color: ColorsManager.orange,
          background: ColorsManager.hotBackground,
        );
      case NotificationType.newEvent:
        return (
          icon: Icons.confirmation_number_rounded,
          color: ColorsManager.chairColor,
          background: ColorsManager.ticketBackground,
        );
      case NotificationType.ticketConfirmed:
        return (
          icon: Icons.check_circle_rounded,
          color: ColorsManager.confirmed,
          background: ColorsManager.confirmedBackground,
        );
      case NotificationType.profileUpdated:
        return (
          icon: Icons.notifications_rounded,
          color: ColorsManager.profileNotification,
          background: ColorsManager.profileNotificationBackground,
        );
      case NotificationType.artistFollowed:
        return (
          icon: Icons.favorite_rounded,
          color: ColorsManager.favourite,
          background: ColorsManager.favouriteBackground,
        );
      case NotificationType.general:
        return (
          icon: Icons.notifications_rounded,
          color: ColorsManager.gray2,
          background: ColorsManager.thirdBlue,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _style;
    return Container(
      width: 44.w,
      height: 44.w,
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(style.icon, color: style.color, size: 24.sp),
    );
  }
}
