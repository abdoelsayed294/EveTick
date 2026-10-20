import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/notifications/data/models/notification_filter.dart';
import 'package:evetick/features/notifications/data/models/notification_model.dart';
import 'package:evetick/features/notifications/data/notifications_repository.dart';
import 'package:evetick/features/notifications/logic/notifications_cubit/notifications_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsCubit extends Cubit<NotificationsState<List<AppNotification>>> {
  final NotificationsRepository notificationsRepo;
  NotificationsCubit(this.notificationsRepo)
      : super(const NotificationsState.initial());

  final filter = ValueNotifier<NotificationFilter>(NotificationFilter.all);

  List<AppNotification>? get _items =>
      state.whenOrNull(success: (items) => items);

  void setFilter(NotificationFilter value) => filter.value = value;

  Future<void> emitNotificationsStates({bool silent = false}) async {
    if (!silent) emit(const NotificationsState.loading());

    final result = await notificationsRepo.getNotifications();
    if (isClosed) return;
    result.when(
      success: (items) => emit(NotificationsState.success(items)),
      failure: (failure) {
        if (silent && _items != null) return;
        emit(NotificationsState.error(error: failure.message));
      },
    );
  }

  Future<void> markAsRead(String notificationId) async {
    final before = _items;
    if (before == null) return;

    final index = before.indexWhere((n) => n.id == notificationId);
    if (index == -1 || before[index].isRead) return;

    emit(
      NotificationsState.success([
        for (final n in before)
          n.id == notificationId ? n.copyWith(isRead: true) : n,
      ]),
    );

    final result = await notificationsRepo.markAsRead(notificationId);
    if (isClosed) return;
    result.when(
      success: (_) {},
      failure: (_) {
        final current = _items;
        if (current == null) return;
        emit(
          NotificationsState.success([
            for (final n in current)
              n.id == notificationId ? n.copyWith(isRead: false) : n,
          ]),
        );
      },
    );
  }

  @override
  Future<void> close() {
    filter.dispose();
    return super.close();
  }
}
