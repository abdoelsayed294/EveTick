import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/following_organizers/data/following_repository.dart';
import 'package:evetick/features/organizer_profile/data/organizer_profile_repository.dart';
import 'package:evetick/features/organizer_profile/logic/organizer_profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrganizerProfileCubit extends Cubit<OrganizerProfileState> {
  final OrganizerProfileRepository repo;
  final FollowingRepository followingRepo;

  OrganizerProfileCubit(this.repo, this.followingRepo)
      : super(const OrganizerProfileState());

  Future<void> load(String organizerId) async {
    emit(const OrganizerProfileState());

    final result = await repo.getProfile(organizerId);
    final following = await followingRepo.isFollowing(organizerId);
    if (isClosed) return;

    result.when(
      success: (profile) => emit(
        state.copyWith(
          status: OrganizerProfileStatus.success,
          profile: profile,
          isFollowing: following,
          canFollow: followingRepo.canFollow(organizerId),
        ),
      ),
      failure: (error) => emit(
        state.copyWith(
          status: OrganizerProfileStatus.error,
          errorMessage: error.message,
        ),
      ),
    );
  }

  void selectTab(OrganizerProfileTab tab) => emit(state.copyWith(tab: tab));

  /// Updates the button and the counter immediately, then saves;
  /// rolls back if saving fails. The real counter is kept by a Cloud Function.
  Future<void> toggleFollow() async {
    final profile = state.profile;
    if (profile == null || !state.canFollow) return;

    final wasFollowing = state.isFollowing;
    final followers = wasFollowing
        ? (profile.followers > 0 ? profile.followers - 1 : 0)
        : profile.followers + 1;
    emit(state.copyWith(
      isFollowing: !wasFollowing,
      profile: profile.copyWith(followers: followers),
    ));

    final saved =
        await followingRepo.setFollowing(profile.id, follow: !wasFollowing);
    if (!saved && !isClosed) {
      emit(state.copyWith(isFollowing: wasFollowing, profile: profile));
    }
  }
}
