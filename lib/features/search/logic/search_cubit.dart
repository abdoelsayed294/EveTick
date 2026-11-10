import 'package:evetick/core/services/result.dart' hide Success;
import 'package:evetick/features/home/data/repo/home_repo.dart';
import 'package:evetick/features/search/data/models/search_filters_model.dart';
import 'package:evetick/features/search/data/search_history_repository.dart';
import 'package:evetick/features/search/logic/search_data.dart';
import 'package:evetick/features/search/logic/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCubit extends Cubit<SearchState> {
  final HomeRepo homeRepo;
  final SearchHistoryRepository historyRepo;

  SearchCubit(this.homeRepo, this.historyRepo)
      : super(const SearchState.initial());

  SearchData _data = const SearchData();

  SearchData get data => _data;

  Future<void> load({bool openFilters = false}) async {
    _data = SearchData(isFilterOpen: openFilters);
    emit(const SearchState.loading());

    final eventsResult = await homeRepo.getLiveEvents();
    final favorites = await homeRepo.getFavoriteIds();
    final recent = await historyRepo.getRecent();
    if (isClosed) return;

    eventsResult.when(
      success: (events) {
        _data = _data.copyWith(
          events: events,
          recentSearches: recent,
          favoriteIds: favorites.when(
            success: (ids) => ids,
            failure: (_) => _data.favoriteIds,
          ),
        );
        emit(SearchState.success(_data));
      },
      failure: (failure) {
        emit(SearchState.error(error: failure.message));
      },
    );
  }

  Future<void> refreshFavorites() async {
    final favorites = await homeRepo.getFavoriteIds();
    if (isClosed) return;
    favorites.when(
      success: (ids) => _emitData(_data.copyWith(favoriteIds: ids)),
      failure: (_) {},
    );
  }

  void setQuery(String query) => _emitData(_data.copyWith(query: query));

  Future<void> submitSearch(String query) async {
    _emitData(_data.copyWith(query: query));
    await saveRecent(query);
  }

  Future<void> saveRecent(String query) async {
    if (query.trim().isEmpty) return;
    final recent = await historyRepo.add(query);
    if (isClosed) return;
    _emitData(_data.copyWith(recentSearches: recent));
  }

  Future<void> clearRecent() async {
    await historyRepo.clear();
    if (isClosed) return;
    _emitData(_data.copyWith(recentSearches: const []));
  }

  bool stepBack() {
    if (_data.isFilterOpen) {
      _emitData(_data.copyWith(isFilterOpen: false));
      return true;
    }
    if (_data.showResults) {
      _emitData(
        _data.copyWith(
          query: '',
          filters: _data.filters.copyWith(clearCategory: true),
        ),
      );
      return true;
    }
    return false;
  }

  void toggleFilterPanel() =>
      _emitData(_data.copyWith(isFilterOpen: !_data.isFilterOpen));

  void applyFilters(SearchFilters filters) =>
      _emitData(_data.copyWith(filters: filters, isFilterOpen: false));

  void toggleUpcoming() => _emitData(
        _data.copyWith(
          filters: _data.filters.copyWith(
            upcomingOnly: !_data.filters.upcomingOnly,
          ),
        ),
      );

  void toggleThisWeekend() => _emitData(
        _data.copyWith(
          filters: _data.filters.copyWith(
            thisWeekend: !_data.filters.thisWeekend,
          ),
        ),
      );

  void togglePriceLowToHigh() => _emitData(
        _data.copyWith(
          filters: _data.filters.copyWith(
            priceLowToHigh: !_data.filters.priceLowToHigh,
          ),
        ),
      );

  Future<void> toggleFavorite(String eventId) async {
    final wasFavorite = _data.favoriteIds.contains(eventId);
    final updated = Set<String>.of(_data.favoriteIds);
    wasFavorite ? updated.remove(eventId) : updated.add(eventId);
    _emitData(_data.copyWith(favoriteIds: updated));

    final result =
        await homeRepo.setFavorite(eventId, isFavorite: !wasFavorite);
    if (isClosed) return;
    result.when(
      success: (_) {},
      failure: (_) {
        final rollback = Set<String>.of(_data.favoriteIds);
        wasFavorite ? rollback.add(eventId) : rollback.remove(eventId);
        _emitData(_data.copyWith(favoriteIds: rollback));
      },
    );
  }

  void _emitData(SearchData data) {
    _data = data;
    if (state is Success) emit(SearchState.success(_data));
  }
}
