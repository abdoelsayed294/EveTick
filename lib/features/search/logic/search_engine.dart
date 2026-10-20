import 'package:evetick/features/home/data/models/home_event_model.dart';
import 'package:evetick/features/home/logic/home_ranking.dart';
import 'package:evetick/features/search/data/models/search_filters_model.dart';
import 'package:evetick/features/search/data/models/search_sort.dart';

class SearchEngine {
  static const int maxTrending = 5;

  static List<HomeEvent> notEnded(List<HomeEvent> events, DateTime now) {
    return events.where((e) {
      final end = e.endDate ?? e.startDate;
      return end == null || !end.isBefore(now);
    }).toList();
  }

  static List<HomeEvent> apply(
    List<HomeEvent> events,
    String query,
    SearchFilters filters, {
    DateTime? now,
  }) {
    final time = now ?? DateTime.now();
    final words = query
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();

    final matches = notEnded(events, time).where((e) {
      final text = '${e.title} ${e.category} ${e.placeText}'.toLowerCase();
      if (!words.every(text.contains)) return false;
      if (!_matchesCategory(e, filters.category)) return false;

      final start = e.startDate;
      if (filters.upcomingOnly && start != null && !start.isAfter(time)) {
        return false;
      }
      if (filters.thisWeekend && !_isThisWeekend(start, time)) return false;
      return true;
    }).toList();

    return _sorted(matches, filters);
  }

  static List<String> trendingTitles(List<HomeEvent> events, {DateTime? now}) {
    final upcoming = notEnded(events, now ?? DateTime.now());
    final titles = <String>[];
    for (final event in HomeRanking.popular(upcoming)) {
      final title = event.title.trim();
      if (title.isNotEmpty && !titles.contains(title)) titles.add(title);
      if (titles.length == maxTrending) break;
    }
    return titles;
  }

  static List<String> categories(List<HomeEvent> events) {
    final counts = <String, int>{};
    for (final e in events) {
      final c = e.category.trim();
      if (c.isNotEmpty) counts[c] = (counts[c] ?? 0) + 1;
    }
    return counts.keys.toList()
      ..sort((a, b) => counts[b]!.compareTo(counts[a]!));
  }

  static bool _matchesCategory(HomeEvent e, String? category) {
    if (category == null) return true;
    if (category == SearchFilters.freeCategory) return e.minPrice == 0;
    return e.category == category;
  }

  static bool _isThisWeekend(DateTime? start, DateTime now) {
    if (start == null) return false;
    final today = DateTime(now.year, now.month, now.day);
    final DateTime from;
    final DateTime to;
    if (now.weekday == DateTime.sunday) {
      from = today;
      to = today.add(const Duration(days: 1));
    } else {
      from = today.add(Duration(days: DateTime.saturday - now.weekday));
      to = from.add(const Duration(days: 2));
    }
    return !start.isBefore(from) && start.isBefore(to);
  }

  static List<HomeEvent> _sorted(List<HomeEvent> events, SearchFilters f) {
    if (f.priceLowToHigh) {
      return [...events]..sort((a, b) {
          final aPrice = a.minPrice;
          final bPrice = b.minPrice;
          if (aPrice == null && bPrice == null) return 0;
          if (aPrice == null) return 1;
          if (bPrice == null) return -1;
          return aPrice.compareTo(bPrice);
        });
    }
    if (f.sort == SearchSort.popularity) return HomeRanking.popular(events);

    return [...events]..sort((a, b) {
        final aDate = a.startDate;
        final bDate = b.startDate;
        if (aDate == null && bDate == null) return 0;
        if (aDate == null) return 1;
        if (bDate == null) return -1;
        return aDate.compareTo(bDate);
      });
  }
}
