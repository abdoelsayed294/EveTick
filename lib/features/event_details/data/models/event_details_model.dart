import 'package:evetick/features/event_details/data/models/event_organizer_model.dart';
import 'package:evetick/features/home/data/models/home_event_model.dart';
import 'package:evetick/features/home/logic/home_ranking.dart';

/// Read model of `events/{id}` for the event landing page.
class EventDetails {
  const EventDetails({
    required this.id,
    required this.title,
    required this.coverImageUrl,
    required this.category,
    required this.description,
    required this.startAt,
    required this.endAt,
    required this.isOnline,
    required this.isSoldOut,
    required this.isHighDemand,
    required this.galleryImagesUrls,
    this.location,
    this.eventUrl,
    this.minPrice,
    this.maxPrice,
    this.organizerId,
    this.organizer,
  });

  final String id;
  final String title;
  final String coverImageUrl;
  final String category;
  final String description;
  final String startAt;
  final String endAt;
  final bool isOnline;
  final bool isSoldOut;
  final bool isHighDemand;
  final List<String> galleryImagesUrls;
  final String? location;
  final String? eventUrl;
  final double? minPrice;
  final double? maxPrice;
  final String? organizerId;
  final EventOrganizer? organizer;

  factory EventDetails.fromJson(Map<String, dynamic> json) {
    // Sales numbers / sold out / min price are already computed here.
    final home = HomeEvent.fromJson(json);

    final prices = (json['ticketTiers'] as List<dynamic>? ?? [])
        .map((t) => ((t as Map)['ticketPrice'] as num?)?.toDouble())
        .whereType<double>()
        .toList()
      ..sort();

    final organizerName = (json['organizerName'] as String?)?.trim();

    return EventDetails(
      id: home.id,
      title: home.title,
      coverImageUrl: home.coverImageUrl,
      category: home.category,
      description: json['eventDescription'] as String? ?? '',
      startAt: home.startAt,
      endAt: home.endAt,
      isOnline: home.isOnline,
      isSoldOut: home.isSoldOut,
      isHighDemand: !home.isSoldOut &&
          (home.soldLast7Days >= HomeRanking.minRecentSoldForTrending ||
              home.ticketsSold >= HomeRanking.minSoldForTopSelling),
      galleryImagesUrls: (json['galleryImagesUrls'] as List<dynamic>? ?? [])
          .whereType<String>()
          .where((url) => url.isNotEmpty)
          .toList(),
      location: home.location,
      eventUrl: json['eventUrl'] as String?,
      minPrice: home.minPrice,
      maxPrice: prices.isEmpty ? null : prices.last,
      organizerId: (json['organizerId'] as String?)?.trim(),
      organizer: (organizerName == null || organizerName.isEmpty)
          ? null
          : EventOrganizer(
              name: organizerName,
              avatarUrl: json['organizerAvatarUrl'] as String?,
              followers: (json['organizerFollowers'] as num?)?.toInt() ?? 0,
            ),
    );
  }

  /// Same event with the organizer loaded from `users/{organizerId}`.
  EventDetails withOrganizer(EventOrganizer? organizer) => EventDetails(
        id: id,
        title: title,
        coverImageUrl: coverImageUrl,
        category: category,
        description: description,
        startAt: startAt,
        endAt: endAt,
        isOnline: isOnline,
        isSoldOut: isSoldOut,
        isHighDemand: isHighDemand,
        galleryImagesUrls: galleryImagesUrls,
        location: location,
        eventUrl: eventUrl,
        minPrice: minPrice,
        maxPrice: maxPrice,
        organizerId: organizerId,
        organizer: organizer,
      );

  /// Cover first, then the gallery (no duplicates, no empty urls).
  List<String> get images => [
        if (coverImageUrl.isNotEmpty) coverImageUrl,
        ...galleryImagesUrls.where((u) => u != coverImageUrl),
      ];

  /// Where the event happens, for display.
  String get placeText {
    final value = location?.trim() ?? '';
    if (value.isNotEmpty) return value;
    return isOnline ? 'Online event' : '';
  }

  bool get hasMap => !isOnline && (location?.trim().isNotEmpty ?? false);

  /// "$100" / "From $100" (tiers have different prices) / "Free".
  String get priceText {
    final min = minPrice;
    if (min == null) return '';
    if (min == 0 && (maxPrice ?? 0) == 0) return 'Free';
    final shown = _money(min);
    final hasRange = maxPrice != null && maxPrice != min;
    return hasRange ? 'From $shown' : shown;
  }

  static String _money(double value) => value == value.roundToDouble()
      ? '\$${value.toStringAsFixed(0)}'
      : '\$${value.toStringAsFixed(2)}';
}
