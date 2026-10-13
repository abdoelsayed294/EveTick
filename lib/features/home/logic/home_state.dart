import 'package:evetick/features/home/data/models/home_event_model.dart';
import 'package:evetick/features/home/logic/home_ranking.dart';

enum HomeStatus { loading, success, error }

class HomeState {
  const HomeState({
    this.status = HomeStatus.loading,
    this.errorMessage,
    this.events = const [],
    this.favoriteIds = const {},
    this.selectedCategory,
    this.searchQuery = '',
  });

  final HomeStatus status;
  final String? errorMessage;

  /// Upcoming / ongoing live events, soonest first.
  final List<HomeEvent> events;
  final Set<String> favoriteIds;

  /// null = "All"
  final String? selectedCategory;
  final String searchQuery;

  /// Category chips come from the events themselves, most used first.
  List<String> get categories {
    final counts = <String, int>{};
    for (final e in events) {
      final c = e.category.trim();
      if (c.isNotEmpty) counts[c] = (counts[c] ?? 0) + 1;
    }
    final names = counts.keys.toList()
      ..sort((a, b) => counts[b]!.compareTo(counts[a]!));
    return names;
  }

  /// Events after the category chip and the search box.
  List<HomeEvent> get filteredEvents {
    final query = searchQuery.trim().toLowerCase();
    return events.where((e) {
      final matchesCategory =
          selectedCategory == null || e.category == selectedCategory;
      final matchesQuery = query.isEmpty ||
          e.title.toLowerCase().contains(query) ||
          e.category.toLowerCase().contains(query) ||
          e.placeText.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  /// eventId -> "TOP SELLING" / "TRENDING", from real sales.
  Map<String, String> get badges => HomeRanking.badges(events);

  List<HomeEvent> get featuredEvents => HomeRanking.featured(filteredEvents);

  List<HomeEvent> get popularEvents => HomeRanking.popular(filteredEvents);

  HomeState copyWith({
    HomeStatus? status,
    String? errorMessage,
    List<HomeEvent>? events,
    Set<String>? favoriteIds,
    String? selectedCategory,
    bool clearCategory = false,
    String? searchQuery,
  }) {
    return HomeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      events: events ?? this.events,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      selectedCategory:
          clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
