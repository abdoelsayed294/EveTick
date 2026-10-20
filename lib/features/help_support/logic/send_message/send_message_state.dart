import 'package:freezed_annotation/freezed_annotation.dart';

part 'send_message_state.freezed.dart';

@freezed
class SendMessageState<T> with _$SendMessageState<T> {
  const factory SendMessageState.initial() = _Initial;
  const factory SendMessageState.loading() = Loading;
  const factory SendMessageState.success(T data) = Success<T>;
  const factory SendMessageState.error({required String error}) = Error;
}
