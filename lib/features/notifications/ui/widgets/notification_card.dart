import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/features/notifications/data/models/notification_model.dart';
import 'package:evetick/features/notifications/ui/widgets/notification_type_icon.dart';
import 'package:evetick/features/notifications/ui/widgets/notification_unread_dot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.notification,
    required this.timeLabel,
    required this.onTap,
  });

  final AppNotification notification;
  final String timeLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final unread = !notification.isRead;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: context.colors.lightBlue,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NotificationTypeIcon(type: notification.type),
            horizontalSpace(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: unread ? FontWeight.w700 : FontWeight.w500,
                      color: unread
                          ? context.colors.white
                          : context.colors.lightGray,
                    ),
                  ),
                  if (notification.body.isNotEmpty) ...[
                    verticalSpace(8),
                    Text(
                      notification.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.sp,
                        height: 1.4,
                        color: context.colors.lightGray,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            horizontalSpace(8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  timeLabel,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: context.colors.lightGray,
                  ),
                ),
                if (unread) ...[
                  verticalSpace(10),
                  const NotificationUnreadDot(),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
