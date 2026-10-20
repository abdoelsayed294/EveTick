import 'package:freezed_annotation/freezed_annotation.dart';

part 'help_state.freezed.dart';

@freezed
class HelpState<T> with _$HelpState<T> {
  const factory HelpState.initial() = _Initial;
  const factory HelpState.loading() = Loading;
  const factory HelpState.success(T data) = Success<T>;
  const factory HelpState.error({required String error}) = Error;
}
