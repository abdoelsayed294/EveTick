import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_details_state.freezed.dart';

@freezed
class EventDetailsState<T> with _$EventDetailsState<T> {
  const factory EventDetailsState.initial() = _Initial;
  const factory EventDetailsState.loading() = Loading;
  const factory EventDetailsState.success(T data) = Success<T>;
  const factory EventDetailsState.error({required String error}) = Error;
}
