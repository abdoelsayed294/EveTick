import 'package:freezed_annotation/freezed_annotation.dart';

part 'notifications_state.freezed.dart';

@freezed
class NotificationsState<T> with _$NotificationsState<T> {
  const factory NotificationsState.initial() = _Initial;
  const factory NotificationsState.loading() = NotificationsLoading;
  const factory NotificationsState.success(T data) = NotificationsSuccess<T>;
  const factory NotificationsState.error({required String error}) =
      NotificationsError;
}
