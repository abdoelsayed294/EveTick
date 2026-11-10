import 'package:evetick/core/widgets/app_error_view.dart';
import 'package:evetick/features/notifications/data/models/notification_model.dart';
import 'package:evetick/features/notifications/logic/notifications_cubit/notifications_cubit.dart';
import 'package:evetick/features/notifications/logic/notifications_cubit/notifications_state.dart';
import 'package:evetick/features/notifications/ui/widgets/notifications_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsBlocBuilder extends StatelessWidget {
  const NotificationsBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit,
        NotificationsState<List<AppNotification>>>(
      builder: (context, state) {
        return state.when(
          initial: () => const SizedBox.shrink(),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error) => AppErrorView(
            message: error,
            onRetry: () =>
                context.read<NotificationsCubit>().emitNotificationsStates(),
          ),
          success: (items) => NotificationsList(notifications: items),
        );
      },
    );
  }
}
