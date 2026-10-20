import 'package:evetick/features/notifications/data/models/notification_filter.dart';
import 'package:evetick/features/notifications/data/models/notification_model.dart';
import 'package:evetick/features/notifications/logic/notifications_cubit/notifications_cubit.dart';
import 'package:evetick/features/notifications/ui/widgets/notification_list_item.dart';
import 'package:evetick/features/notifications/ui/widgets/notifications_earlier_header.dart';
import 'package:evetick/features/notifications/ui/widgets/notifications_empty_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// The loaded notifications: filtered by the selected chip, the recent ones
/// first, then the "EARLIER" section. Pull down to refresh.
class NotificationsList extends StatelessWidget {
  const NotificationsList({super.key, required this.notifications});

  final List<AppNotification> notifications;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NotificationsCubit>();

    return ValueListenableBuilder<NotificationFilter>(
      valueListenable: cubit.filter,
      builder: (context, filter, _) {
        final now = DateTime.now();
        final items = notifications.where(filter.matches).toList();
        final recent = items.where((n) => n.isRecent(now)).toList();
        final earlier = items.where((n) => !n.isRecent(now)).toList();

        return RefreshIndicator(
          onRefresh: () => cubit.emitNotificationsStates(silent: true),
          child: items.isEmpty
              ? const NotificationsEmptyView()
              : ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 32.h),
                  children: [
                    for (final n in recent)
                      NotificationListItem(notification: n, now: now),
                    if (earlier.isNotEmpty) ...[
                      const NotificationsEarlierHeader(),
                      for (final n in earlier)
                        NotificationListItem(notification: n, now: now),
                    ],
                  ],
                ),
        );
      },
    );
  }
}
