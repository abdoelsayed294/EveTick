import 'package:evetick/core/helpers/sales_day_key.dart';

/// Light read model of `events/{id}` for the home lists.
///
/// Fields used besides the basic ones:
///   isFeatured: true  -> pinned first in "Featured Events" (set by the admin)
///   ticketsSold       -> total tickets sold (written by the booking transaction)
///   salesByDay        -> {"d20261013": 5, ...} tickets sold per UTC day
class HomeEvent {
  const HomeEvent({
    required this.id,
    required this.title,
    required this.coverImageUrl,
    required this.category,
    required this.startAt,
    required this.endAt,
    required this.isOnline,
    required this.isSoldOut,
    required this.isFeatured,
    required this.ticketsSold,
    required this.soldLast7Days,
    this.location,
    this.minPrice,
  });

  final String id;
  final String title;
  final String coverImageUrl;
  final String category;
  final String startAt;
  final String endAt;
  final bool isOnline;
  final bool isSoldOut;
  final bool isFeatured;
  final int ticketsSold;
  final int soldLast7Days;
  final String? location;
  final double? minPrice;

  factory HomeEvent.fromJson(Map<String, dynamic> json) {
    final tiers = (json['ticketTiers'] as List<dynamic>? ?? [])
        .map((t) => Map<String, dynamic>.from(t as Map))
        .toList();

    final available =
        tiers.where((t) => ((t['ticketQuantity'] as num?) ?? 0) > 0).toList();
    final priced = available.isNotEmpty ? available : tiers;
    final prices = priced
        .map((t) => (t['ticketPrice'] as num?)?.toDouble())
        .whereType<double>()
        .toList()
      ..sort();

    return HomeEvent(
      id: json['eventId'] as String,
      title: json['eventTitle'] as String? ?? '',
      coverImageUrl: json['coverImageUrl'] as String? ?? '',
      category: json['eventCategory'] as String? ?? '',
      startAt: json['startAt'] as String? ?? '',
      endAt: json['endAt'] as String? ?? '',
      isOnline: json['isOnlineEvent'] as bool? ?? false,
      isSoldOut: tiers.isNotEmpty && available.isEmpty,
      isFeatured: json['isFeatured'] as bool? ?? false,
      ticketsSold: (json['ticketsSold'] as num?)?.toInt() ?? 0,
      soldLast7Days: _soldInLastDays(json['salesByDay'], 7),
      location: json['eventLocation'] as String?,
      minPrice: prices.isEmpty ? null : prices.first,
    );
  }

  /// Sum of the daily counters of the last [days] days (today included).
  static int _soldInLastDays(Object? salesByDay, int days) {
    if (salesByDay is! Map) return 0;
    final now = DateTime.now().toUtc();
    final today = DateTime.utc(now.year, now.month, now.day);
    final first = today.subtract(Duration(days: days - 1));

    var total = 0;
    salesByDay.forEach((key, value) {
      final day = parseSalesDayKey(key.toString());
      if (day != null && !day.isBefore(first) && value is num) {
        total += value.toInt();
      }
    });
    return total;
  }

  DateTime? get startDate => DateTime.tryParse(startAt);
  DateTime? get endDate => DateTime.tryParse(endAt);

  /// Where the event happens, for display.
  String get placeText {
    final value = location?.trim() ?? '';
    if (value.isNotEmpty) return value;
    return isOnline ? 'Online event' : '';
  }

  /// "Free" / "From $45", also for sold out events (list cards show a
  /// separate "Sold Out" tag).
  String get startingPriceText {
    final price = minPrice;
    if (price == null) return '';
    if (price == 0) return 'Free';
    final shown = price == price.roundToDouble()
        ? price.toStringAsFixed(0)
        : price.toStringAsFixed(2);
    return 'From \$$shown';
  }

  String get priceText => isSoldOut ? 'Sold out' : startingPriceText;
}
