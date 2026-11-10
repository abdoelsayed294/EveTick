import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/following_organizers/data/following_repository.dart';
import 'package:evetick/features/following_organizers/data/models/followed_organizer_model.dart';
import 'package:evetick/features/following_organizers/logic/following_organizers_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FollowingOrganizersCubit extends Cubit<FollowingOrganizersState> {
  final FollowingRepository repo;

  FollowingOrganizersCubit(this.repo)
      : super(const FollowingOrganizersState.initial());

  List<FollowedOrganizer> _organizers = [];
  String _query = '';

  int get totalCount => _organizers.length;

  List<FollowedOrganizer> get _visible {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return _organizers;
    return _organizers.where((o) => o.name.toLowerCase().contains(q)).toList();
  }

  Future<void> load({bool silent = false}) async {
    if (!silent) emit(const FollowingOrganizersState.loading());

    final result = await repo.getFollowedOrganizers();
    if (isClosed) return;
    result.when(
      success: (organizers) {
        _organizers = organizers;
        emit(FollowingOrganizersState.success(_visible));
      },
      failure: (failure) {
        if (silent && _organizers.isNotEmpty) return;
        emit(FollowingOrganizersState.error(error: failure.message));
      },
    );
  }

  void search(String query) {
    _query = query;
    emit(FollowingOrganizersState.success(_visible));
  }

  Future<void> toggleFollow(String organizerId) async {
    final index = _organizers.indexWhere((o) => o.id == organizerId);
    if (index < 0) return;
    final before = _organizers[index];

    final nowFollowing = !before.isFollowing;
    final followers = nowFollowing
        ? before.followers + 1
        : (before.followers > 0 ? before.followers - 1 : 0);
    _replace(
      index,
      before.copyWith(isFollowing: nowFollowing, followers: followers),
    );

    final result = await repo.setFollowing(organizerId, follow: nowFollowing);
    if (isClosed) return;
    result.when(
      success: (_) {},
      failure: (_) {
        final current = _organizers.indexWhere((o) => o.id == organizerId);
        if (current >= 0) _replace(current, before);
      },
    );
  }

  void _replace(int index, FollowedOrganizer item) {
    _organizers = [..._organizers]..[index] = item;
    emit(FollowingOrganizersState.success(_visible));
  }
}
