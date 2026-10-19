import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/following_organizers/data/following_repository.dart';
import 'package:evetick/features/following_organizers/data/models/followed_organizer_model.dart';
import 'package:evetick/features/following_organizers/logic/following_organizers_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FollowingOrganizersCubit extends Cubit<FollowingOrganizersState> {
  final FollowingRepository repo;

  FollowingOrganizersCubit(this.repo) : super(const FollowingOrganizersState());

  /// [silent] keeps the current list on screen (pull to refresh, coming
  /// back from an organizer page).
  Future<void> load({bool silent = false}) async {
    if (!silent) emit(const FollowingOrganizersState());

    final result = await repo.getFollowedOrganizers();
    if (isClosed) return;
    result.when(
      success: (organizers) => emit(
        state.copyWith(
          status: FollowingOrganizersStatus.success,
          organizers: organizers,
        ),
      ),
      failure: (error) {
        // On a silent refresh keep what the user already sees.
        if (silent && state.organizers.isNotEmpty) return;
        emit(
          state.copyWith(
            status: FollowingOrganizersStatus.error,
            errorMessage: error.message,
          ),
        );
      },
    );
  }

  void search(String query) => emit(state.copyWith(query: query));

  /// Follow / Following button. The row stays in the list so the user can
  /// follow it again. Updates immediately, then saves; rolls back on failure.
  Future<void> toggleFollow(String organizerId) async {
    final index = state.organizers.indexWhere((o) => o.id == organizerId);
    if (index < 0) return;
    final before = state.organizers[index];

    final nowFollowing = !before.isFollowing;
    final followers = nowFollowing
        ? before.followers + 1
        : (before.followers > 0 ? before.followers - 1 : 0);
    _replace(index, before.copyWith(isFollowing: nowFollowing, followers: followers));

    final saved = await repo.setFollowing(organizerId, follow: nowFollowing);
    if (!saved && !isClosed) {
      final current = state.organizers.indexWhere((o) => o.id == organizerId);
      if (current >= 0) _replace(current, before);
    }
  }

  void _replace(int index, FollowedOrganizer item) {
    final list = [...state.organizers];
    list[index] = item;
    emit(state.copyWith(organizers: list));
  }
}
