import 'package:evetick/core/services/result.dart' hide Success;
import 'package:evetick/features/event_details/data/event_details_repository.dart';
import 'package:evetick/features/event_details/logic/event_details_data.dart';
import 'package:evetick/features/event_details/logic/event_details_state.dart';
import 'package:evetick/features/home/data/repo/home_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventDetailsCubit extends Cubit<EventDetailsState> {
  final EventDetailsRepository repo;
  final HomeRepo homeRepo;

  EventDetailsCubit(this.repo, this.homeRepo)
      : super(const EventDetailsState.initial());

  EventDetailsData? _data;

  Future<void> getEventDetails(String eventId) async {
    _data = null;
    emit(const EventDetailsState.loading());

    final result = await repo.getEventDetails(eventId);
    final favorites = await homeRepo.getFavoriteIds();
    if (isClosed) return;

    result.when(
      success: (event) {
        final data = EventDetailsData(
          event: event,
          isFavorite: favorites.when(
            success: (ids) => ids.contains(event.id),
            failure: (_) => false,
          ),
        );
        _data = data;
        emit(EventDetailsState.success(data));

        if (event.hasMap) _loadCoordinates(event.location!);
        final organizerId = event.organizerId;
        if (organizerId != null && event.organizer != null) {
          _loadFollowState(organizerId);
        }
      },
      failure: (failure) {
        emit(EventDetailsState.error(error: failure.message));
      },
    );
  }

  Future<void> refreshOrganizer() async {
    final event = _data?.event;
    final organizerId = event?.organizerId;
    if (event == null || organizerId == null) return;

    final following = await repo.isFollowing(organizerId);
    final fresh = await repo.refreshOrganizer(event);
    if (isClosed) return;

    final current = _data;
    if (current == null) return;
    _emitData(current.copyWith(isFollowing: following, event: fresh));
  }

  Future<void> toggleFavorite() async {
    final before = _data;
    if (before == null) return;

    final wasFavorite = before.isFavorite;
    _emitData(before.copyWith(isFavorite: !wasFavorite));

    final result = await homeRepo.setFavorite(
      before.event.id,
      isFavorite: !wasFavorite,
    );
    if (isClosed) return;
    result.when(
      success: (_) {},
      failure: (_) {
        final current = _data;
        if (current == null) return;
        _emitData(current.copyWith(isFavorite: wasFavorite));
      },
    );
  }

  Future<void> toggleFollow() async {
    final before = _data;
    final event = before?.event;
    final organizer = event?.organizer;
    final organizerId = event?.organizerId;
    if (before == null ||
        event == null ||
        organizer == null ||
        organizerId == null) {
      return;
    }
    if (!repo.canFollow(organizerId)) return;

    final wasFollowing = before.isFollowing;
    final newFollowers = wasFollowing
        ? (organizer.followers > 0 ? organizer.followers - 1 : 0)
        : organizer.followers + 1;
    _emitData(
      before.copyWith(
        isFollowing: !wasFollowing,
        event: event.withOrganizer(
          organizer.copyWith(followers: newFollowers),
        ),
      ),
    );

    final result = await repo.setFollowing(organizerId, follow: !wasFollowing);
    if (isClosed) return;
    result.when(
      success: (_) {},
      failure: (_) {
        final current = _data;
        if (current == null) return;
        _emitData(current.copyWith(isFollowing: wasFollowing, event: event));
      },
    );
  }

  Future<void> _loadFollowState(String organizerId) async {
    final following = await repo.isFollowing(organizerId);
    final current = _data;
    if (!following || isClosed || current == null) return;
    _emitData(current.copyWith(isFollowing: true));
  }

  Future<void> _loadCoordinates(String address) async {
    final coordinates = await repo.findCoordinates(address);
    final current = _data;
    if (coordinates == null || isClosed || current == null) return;
    _emitData(current.copyWith(coordinates: coordinates));
  }

  void _emitData(EventDetailsData data) {
    _data = data;
    if (state is Success) emit(EventDetailsState.success(data));
  }
}
