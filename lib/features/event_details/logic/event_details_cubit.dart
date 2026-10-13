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
      },
      failure: (error) => emit(
        state.copyWith(
          status: EventDetailsStatus.error,
          errorMessage: error.message,
        ),
      ),
    );
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

  // TODO: persist follows once organizers exist in Firestore.
  void toggleFollow() => emit(state.copyWith(isFollowing: !state.isFollowing));
}
