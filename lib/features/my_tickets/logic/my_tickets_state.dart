import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_tickets_state.freezed.dart';

@freezed
class MyTicketsState<T> with _$MyTicketsState<T> {
  const factory MyTicketsState.initial() = _Initial;
  const factory MyTicketsState.loading() = Loading;
  const factory MyTicketsState.success(T data) = Success<T>;
  const factory MyTicketsState.error({required String error}) = Error;
}
