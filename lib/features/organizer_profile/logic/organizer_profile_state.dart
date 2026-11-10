import 'package:freezed_annotation/freezed_annotation.dart';

part 'organizer_profile_state.freezed.dart';

@freezed
class OrganizerProfileState<T> with _$OrganizerProfileState<T> {
  const factory OrganizerProfileState.initial() = _Initial;
  const factory OrganizerProfileState.loading() = Loading;
  const factory OrganizerProfileState.success(T data) = Success<T>;
  const factory OrganizerProfileState.error({required String error}) = Error;
}
