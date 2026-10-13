import 'package:evetick/features/home/data/models/home_event_model.dart';
import 'package:evetick/features/search/data/models/search_filters_model.dart';
import 'package:evetick/features/search/logic/search_engine.dart';

enum SearchStatus { loading, success, error }

class SearchState {
  const SearchState({
    this.status = SearchStatus.loading,
    this.errorMessage,
    this.events = const [],
    this.favoriteIds = const {},
    this.recentSearches = const [],
    this.query = '',
    this.filters = const SearchFilters(),
    this.isFilterOpen = false,
  });

  final SearchStatus status;
  final String? errorMessage;
  final List<HomeEvent> events;
  final Set<String> favoriteIds;
  final List<String> recentSearches;
  final String query;
  final SearchFilters filters;
  final bool isFilterOpen;

  /// Results replace the "trending / recent" page as soon as the user types
  /// or picks a category.
  bool get showResults =>
      query.trim().isNotEmpty || filters.category != null;

  List<HomeEvent> get results =>
      SearchEngine.apply(events, query, filters);

  List<String> get trending => SearchEngine.trendingTitles(events);

  /// Real categories + "Free Events".
  List<String> get categories => [
        ...SearchEngine.categories(events),
        SearchFilters.freeCategory,
      ];

  SearchState copyWith({
    SearchStatus? status,
    String? errorMessage,
    List<HomeEvent>? events,
    Set<String>? favoriteIds,
    List<String>? recentSearches,
    String? query,
    SearchFilters? filters,
    bool? isFilterOpen,
  }) {
    return SearchState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      events: events ?? this.events,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      recentSearches: recentSearches ?? this.recentSearches,
      query: query ?? this.query,
      filters: filters ?? this.filters,
      isFilterOpen: isFilterOpen ?? this.isFilterOpen,
    );
  }
}
