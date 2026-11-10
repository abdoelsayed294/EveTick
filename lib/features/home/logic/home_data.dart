import 'package:evetick/features/home/data/models/home_event_model.dart';
import 'package:evetick/features/home/logic/home_ranking.dart';

class HomeData {
  const HomeData({
    this.events = const [],
    this.favoriteIds = const {},
    this.selectedCategory,
    this.searchQuery = '',
  });

  final List<HomeEvent> events;
  final Set<String> favoriteIds;

  final String? selectedCategory;
  final String searchQuery;

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

  Map<String, String> get badges => HomeRanking.badges(events);

  List<HomeEvent> get featuredEvents => HomeRanking.featured(filteredEvents);

  List<HomeEvent> get popularEvents => HomeRanking.popular(filteredEvents);

  HomeData copyWith({
    List<HomeEvent>? events,
    Set<String>? favoriteIds,
    String? selectedCategory,
    bool clearCategory = false,
    String? searchQuery,
  }) {
    return HomeData(
      events: events ?? this.events,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      selectedCategory:
          clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}
