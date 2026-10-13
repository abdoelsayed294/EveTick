enum SearchSort { popularity, date }

/// Everything the user can change in the filter panel and the quick chips.
class SearchFilters {
  const SearchFilters({
    this.sort = SearchSort.popularity,
    this.category,
    this.upcomingOnly = true,
    this.thisWeekend = false,
    this.priceLowToHigh = false,
  });

  /// "Free Events" is not a real category: it keeps events with price 0.
  static const String freeCategory = 'Free Events';

  final SearchSort sort;

  /// null = all categories.
  final String? category;
  final bool upcomingOnly;
  final bool thisWeekend;

  /// When on, it wins over [sort].
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
