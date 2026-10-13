import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/home/data/repo/home_repo.dart';
import 'package:evetick/features/search/data/models/search_filters_model.dart';
import 'package:evetick/features/search/data/search_history_repository.dart';
import 'package:evetick/features/search/logic/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCubit extends Cubit<SearchState> {
  final HomeRepo homeRepo;
  final SearchHistoryRepository historyRepo;

  SearchCubit(this.homeRepo, this.historyRepo) : super(const SearchState());

  Future<void> load({bool openFilters = false}) async {
    emit(SearchState(isFilterOpen: openFilters));

    final eventsResult = await homeRepo.getLiveEvents();
    final favorites = await homeRepo.getFavoriteIds();
    final recent = await historyRepo.getRecent();

    eventsResult.when(
      success: (events) => emit(
        state.copyWith(
          status: SearchStatus.success,
          events: events,
          recentSearches: recent,
          favoriteIds: favorites.when(
            success: (ids) => ids,
            failure: (_) => state.favoriteIds, // favorites are optional
          ),
        ),
      ),
      failure: (error) => emit(
        state.copyWith(
          status: SearchStatus.error,
          errorMessage: error.message,
        ),
      ),
    );
  }

  /// Only the hearts (used when coming back from an event page).
  Future<void> refreshFavorites() async {
    final favorites = await homeRepo.getFavoriteIds();
    favorites.when(
      success: (ids) => emit(state.copyWith(favoriteIds: ids)),
      failure: (_) {},
    );
  }

  void setQuery(String query) => emit(state.copyWith(query: query));

  /// Typed text -> results now, saved to "Recent Searches" on submit.
  Future<void> submitSearch(String query) async {
    emit(state.copyWith(query: query));
    await saveRecent(query);
  }

  Future<void> saveRecent(String query) async {
    if (query.trim().isEmpty) return;
    final recent = await historyRepo.add(query);
    emit(state.copyWith(recentSearches: recent));
  }

  Future<void> clearRecent() async {
    await historyRepo.clear();
    emit(state.copyWith(recentSearches: const []));
  }

  /// Goes back one level: filter panel -> results -> trending / recent.
  /// Returns false when there is nothing left to close (the screen should
  /// leave).
  bool stepBack() {
    if (state.isFilterOpen) {
      emit(state.copyWith(isFilterOpen: false));
      return true;
    }
    if (state.showResults) {
      emit(
        state.copyWith(
          query: '',
          filters: state.filters.copyWith(clearCategory: true),
        ),
      );
      return true;
    }
    return false;
  }

  void toggleFilterPanel() =>
      emit(state.copyWith(isFilterOpen: !state.isFilterOpen));

  /// "Apply Filters" button: save the filters and close the panel.
  void applyFilters(SearchFilters filters) =>
      emit(state.copyWith(filters: filters, isFilterOpen: false));

  void toggleUpcoming() => emit(
        state.copyWith(
          filters: state.filters.copyWith(
            upcomingOnly: !state.filters.upcomingOnly,
          ),
        ),
      );

  void toggleThisWeekend() => emit(
        state.copyWith(
          filters: state.filters.copyWith(
            thisWeekend: !state.filters.thisWeekend,
          ),
        ),
      );

  void togglePriceLowToHigh() => emit(
        state.copyWith(
          filters: state.filters.copyWith(
            priceLowToHigh: !state.filters.priceLowToHigh,
          ),
        ),
      );

  /// Updates the heart immediately, then saves; rolls back if saving fails.
  Future<void> toggleFavorite(String eventId) async {
    final wasFavorite = state.favoriteIds.contains(eventId);
    final updated = Set<String>.of(state.favoriteIds);
    wasFavorite ? updated.remove(eventId) : updated.add(eventId);
    emit(state.copyWith(favoriteIds: updated));

    final result =
        await homeRepo.setFavorite(eventId, isFavorite: !wasFavorite);
    result.when(
      success: (_) {},
      failure: (_) {
        final rollback = Set<String>.of(state.favoriteIds);
        wasFavorite ? rollback.add(eventId) : rollback.remove(eventId);
        emit(state.copyWith(favoriteIds: rollback));
      },
    );
  }
}
