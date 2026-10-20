import 'package:evetick/features/search/data/models/search_sort.dart';

class SearchFilters {
  const SearchFilters({
    this.sort = SearchSort.popularity,
    this.category,
    this.upcomingOnly = true,
    this.thisWeekend = false,
    this.priceLowToHigh = false,
  });

  static const String freeCategory = 'Free Events';

  final SearchSort sort;

  final String? category;
  final bool upcomingOnly;
  final bool thisWeekend;

  final bool priceLowToHigh;

  SearchFilters copyWith({
    SearchSort? sort,
    String? category,
    bool clearCategory = false,
    bool? upcomingOnly,
    bool? thisWeekend,
    bool? priceLowToHigh,
  }) {
    return SearchFilters(
      sort: sort ?? this.sort,
      category: clearCategory ? null : (category ?? this.category),
      upcomingOnly: upcomingOnly ?? this.upcomingOnly,
      thisWeekend: thisWeekend ?? this.thisWeekend,
      priceLowToHigh: priceLowToHigh ?? this.priceLowToHigh,
    );
  }
}
