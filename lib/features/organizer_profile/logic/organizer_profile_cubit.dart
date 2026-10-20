import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/following_organizers/data/following_repository.dart';
import 'package:evetick/features/organizer_profile/data/organizer_profile_repository.dart';
import 'package:evetick/features/organizer_profile/logic/organizer_profile_data.dart';
import 'package:evetick/features/organizer_profile/logic/organizer_profile_state.dart';
import 'package:evetick/features/organizer_profile/logic/organizer_profile_tab.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrganizerProfileCubit extends Cubit<OrganizerProfileState> {
  final OrganizerProfileRepository repo;
  final FollowingRepository followingRepo;

  OrganizerProfileCubit(this.repo, this.followingRepo)
      : super(const OrganizerProfileState.initial());

  OrganizerProfileData? _data;

  Future<void> load(String organizerId) async {
    _data = null;
    emit(const OrganizerProfileState.loading());

    final result = await repo.getProfile(organizerId);
    final following = await followingRepo.isFollowing(organizerId);
    if (isClosed) return;

    result.when(
      success: (profile) {
        _emitData(
          OrganizerProfileData(
            profile: profile,
            isFollowing: following,
            canFollow: followingRepo.canFollow(organizerId),
          ),
        );
      },
      failure: (failure) {
        emit(OrganizerProfileState.error(error: failure.message));
      },
    );
  }

  void selectTab(OrganizerProfileTab tab) {
    final data = _data;
    if (data == null) return;
    _emitData(data.copyWith(tab: tab));
  }

  Future<void> toggleFollow() async {
    final before = _data;
    if (before == null || !before.canFollow) return;

    final profile = before.profile;
    final wasFollowing = before.isFollowing;
    final followers = wasFollowing
        ? (profile.followers > 0 ? profile.followers - 1 : 0)
        : profile.followers + 1;
    _emitData(
      before.copyWith(
        isFollowing: !wasFollowing,
        profile: profile.copyWith(followers: followers),
      ),
    );

    final result =
        await followingRepo.setFollowing(profile.id, follow: !wasFollowing);
    if (isClosed) return;
    result.when(
      success: (_) {},
      failure: (_) {
        final current = _data;
        if (current == null) return;
        _emitData(current.copyWith(isFollowing: wasFollowing, profile: profile));
      },
    );
  }

  void _emitData(OrganizerProfileData data) {
    _data = data;
    emit(OrganizerProfileState.success(data));
  }
}
