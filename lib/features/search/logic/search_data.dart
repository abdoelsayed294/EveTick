import 'package:evetick/features/home/data/models/home_event_model.dart';
import 'package:evetick/features/search/data/models/search_filters_model.dart';
import 'package:evetick/features/search/logic/search_engine.dart';

class SearchData {
  const SearchData({
    this.events = const [],
    this.favoriteIds = const {},
    this.recentSearches = const [],
    this.query = '',
    this.filters = const SearchFilters(),
    this.isFilterOpen = false,
  });

  final List<HomeEvent> events;
  final Set<String> favoriteIds;
  final List<String> recentSearches;
  final String query;
  final SearchFilters filters;
  final bool isFilterOpen;

  bool get showResults =>
      query.trim().isNotEmpty || filters.category != null;

  List<HomeEvent> get results => SearchEngine.apply(events, query, filters);

  List<String> get trending => SearchEngine.trendingTitles(events);

  List<String> get categories => [
        ...SearchEngine.categories(events),
        SearchFilters.freeCategory,
      ];

  SearchData copyWith({
    List<HomeEvent>? events,
    Set<String>? favoriteIds,
    List<String>? recentSearches,
    String? query,
    SearchFilters? filters,
    bool? isFilterOpen,
  }) {
    return SearchData(
      events: events ?? this.events,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      recentSearches: recentSearches ?? this.recentSearches,
      query: query ?? this.query,
      filters: filters ?? this.filters,
      isFilterOpen: isFilterOpen ?? this.isFilterOpen,
    );
  }
}
