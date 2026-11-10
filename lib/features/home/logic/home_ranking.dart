import 'package:evetick/features/home/data/models/home_event_model.dart';

class HomeRanking {
  static const int minSoldForTopSelling = 10;

  static const int minRecentSoldForTrending = 5;

  static const int maxTrending = 3;
  static const int maxFeatured = 5;

  static const String topSellingLabel = 'TOP SELLING';
  static const String trendingLabel = 'TRENDING';

  static Map<String, String> badges(List<HomeEvent> events) {
    final result = <String, String>{};

    final bySold = events
        .where((e) => e.ticketsSold >= minSoldForTopSelling)
        .toList()
      ..sort((a, b) => b.ticketsSold.compareTo(a.ticketsSold));
    if (bySold.isNotEmpty) result[bySold.first.id] = topSellingLabel;

    final trending = events
        .where((e) =>
            !result.containsKey(e.id) &&
            e.soldLast7Days >= minRecentSoldForTrending)
        .toList()
      ..sort((a, b) => b.soldLast7Days.compareTo(a.soldLast7Days));
    for (final event in trending.take(maxTrending)) {
      result[event.id] = trendingLabel;
    }

    return result;
  }

  static List<HomeEvent> featured(List<HomeEvent> events) {
    final sorted = [...events]..sort((a, b) {
        if (a.isFeatured != b.isFeatured) return a.isFeatured ? -1 : 1;
        final bySales = b.ticketsSold.compareTo(a.ticketsSold);
        return bySales != 0 ? bySales : _bySoonest(a, b);
      });
    return sorted.take(maxFeatured).toList();
  }

  static List<HomeEvent> popular(List<HomeEvent> events) {
    return [...events]..sort((a, b) {
        final bySales = b.ticketsSold.compareTo(a.ticketsSold);
        return bySales != 0 ? bySales : _bySoonest(a, b);
      });
  }

  static int _bySoonest(HomeEvent a, HomeEvent b) {
    final aDate = a.startDate;
    final bDate = b.startDate;
    if (aDate == null && bDate == null) return 0;
    if (aDate == null) return 1;
    if (bDate == null) return -1;
    return aDate.compareTo(bDate);
  }
}
