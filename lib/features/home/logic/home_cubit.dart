import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/home/data/models/home_event_model.dart';
import 'package:evetick/features/home/data/repo/home_repo.dart';
import 'package:evetick/features/home/logic/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo;

  HomeCubit(this.homeRepo) : super(const HomeState());

  /// [silent] keeps the current content on screen (pull to refresh).
  Future<void> load({bool silent = false}) async {
    if (!silent) emit(const HomeState());

    final eventsResult = await homeRepo.getLiveEvents();
    final favoritesResult = await homeRepo.getFavoriteIds();

    final favorites = favoritesResult.when(
      success: (ids) => ids,
      failure: (_) => state.favoriteIds, // favorites are optional
    );

    eventsResult.when(
      success: (events) => emit(
        state.copyWith(
          status: HomeStatus.success,
          events: _upcomingSorted(events),
          favoriteIds: favorites,
        ),
      ),
      failure: (error) {
        // On a silent refresh keep what the user already sees.
        if (silent && state.events.isNotEmpty) return;
        emit(
          state.copyWith(
            status: HomeStatus.error,
            errorMessage: error.message,
          ),
        );
      },
    );
  }

  void selectCategory(String? category) {
    emit(
      category == null
          ? state.copyWith(clearCategory: true)
          : state.copyWith(selectedCategory: category),
    );
  }

  void search(String query) => emit(state.copyWith(searchQuery: query));

  /// Updates the heart immediately, then saves; rolls back if saving fails.
  Future<void> toggleFavorite(String eventId) async {
    final wasFavorite = state.favoriteIds.contains(eventId);
    final updated = Set<String>.of(state.favoriteIds);
    wasFavorite ? updated.remove(eventId) : updated.add(eventId);
    emit(state.copyWith(favoriteIds: updated));

    final result = await homeRepo.setFavorite(eventId, isFavorite: !wasFavorite);
    result.when(
      success: (_) {},
      failure: (_) {
        final rollback = Set<String>.of(state.favoriteIds);
        wasFavorite ? rollback.add(eventId) : rollback.remove(eventId);
        emit(state.copyWith(favoriteIds: rollback));
      },
    );
  }

  /// Drops events that already ended, soonest first.
  List<HomeEvent> _upcomingSorted(List<HomeEvent> events) {
    final now = DateTime.now();
    final upcoming = events.where((e) {
      final end = e.endDate ?? e.startDate;
      return end == null || !end.isBefore(now);
    }).toList();

    upcoming.sort((a, b) {
      final aDate = a.startDate;
      final bDate = b.startDate;
      if (aDate == null && bDate == null) return 0;
      if (aDate == null) return 1;
      if (bDate == null) return -1;
      return aDate.compareTo(bDate);
    });
    return upcoming;
  }
}
