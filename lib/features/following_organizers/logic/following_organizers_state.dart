import 'package:freezed_annotation/freezed_annotation.dart';

part 'following_organizers_state.freezed.dart';

@freezed
class FollowingOrganizersState<T> with _$FollowingOrganizersState<T> {
  const factory FollowingOrganizersState.initial() = _Initial;
  const factory FollowingOrganizersState.loading() = Loading;
  const factory FollowingOrganizersState.success(T data) = Success<T>;
  const factory FollowingOrganizersState.error({required String error}) = Error;
}
