import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/event_details/data/event_details_repository.dart';
import 'package:evetick/features/event_details/logic/event_details_state.dart';
import 'package:evetick/features/home/data/repo/home_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventDetailsCubit extends Cubit<EventDetailsState> {
  final EventDetailsRepository repo;
  final HomeRepo homeRepo;

  EventDetailsCubit(this.repo, this.homeRepo)
      : super(const EventDetailsState());

  Future<void> getEventDetails(String eventId) async {
    emit(const EventDetailsState());

    final result = await repo.getEventDetails(eventId);
    final favorites = await homeRepo.getFavoriteIds();

    result.when(
      success: (event) {
        emit(
          state.copyWith(
            status: EventDetailsStatus.success,
            event: event,
            // favorites are optional: ignore a failure here
            isFavorite: favorites.when(
              success: (ids) => ids.contains(event.id),
              failure: (_) => false,
            ),
          ),
        );
        if (event.hasMap) _loadCoordinates(event.location!);
        final organizerId = event.organizerId;
        if (organizerId != null && event.organizer != null) {
          _loadFollowState(organizerId);
        }
      },
      failure: (error) => emit(
        state.copyWith(
          status: EventDetailsStatus.error,
          errorMessage: error.message,
        ),
      ),
    );
  }

  /// Coming back from the organizer page: the follow state and the
  /// followers count may have changed there.
  Future<void> refreshOrganizer() async {
    final event = state.event;
    final organizerId = event?.organizerId;
    if (event == null || organizerId == null) return;
    final following = await repo.isFollowing(organizerId);
    final fresh = await repo.refreshOrganizer(event);
    if (isClosed) return;
    emit(state.copyWith(isFollowing: following, event: fresh));
  }

  Future<void> _loadFollowState(String organizerId) async {
    final following = await repo.isFollowing(organizerId);
    if (following && !isClosed) emit(state.copyWith(isFollowing: true));
  }

  Future<void> _loadCoordinates(String address) async {
    final coordinates = await repo.findCoordinates(address);
    if (coordinates != null && !isClosed) {
      emit(state.copyWith(coordinates: coordinates));
    }
  }

  /// Updates the heart immediately, then saves; rolls back if saving fails.
  Future<void> toggleFavorite() async {
    final event = state.event;
    if (event == null) return;

    final wasFavorite = state.isFavorite;
    emit(state.copyWith(isFavorite: !wasFavorite));

    final result =
        await homeRepo.setFavorite(event.id, isFavorite: !wasFavorite);
    result.when(
      success: (_) {},
      failure: (_) => emit(state.copyWith(isFavorite: wasFavorite)),
    );
  }

  /// Updates the button and the counter immediately, then saves;
  /// rolls back if saving fails. The real counter is kept by a Cloud Function.
  Future<void> toggleFollow() async {
    final event = state.event;
    final organizer = event?.organizer;
    final organizerId = event?.organizerId;
    if (event == null || organizer == null || organizerId == null) return;
    if (!repo.canFollow(organizerId)) return;

    final wasFollowing = state.isFollowing;
    final newFollowers = wasFollowing
        ? (organizer.followers > 0 ? organizer.followers - 1 : 0)
        : organizer.followers + 1;
    emit(state.copyWith(
      isFollowing: !wasFollowing,
      event: event.withOrganizer(
        organizer.copyWith(followers: newFollowers),
      ),
    ));

    final saved =
        await repo.setFollowing(organizerId, follow: !wasFollowing);
    if (!saved && !isClosed) {
      emit(state.copyWith(isFollowing: wasFollowing, event: event));
    }
  }
}
