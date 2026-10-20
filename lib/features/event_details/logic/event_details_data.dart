import 'package:evetick/features/event_details/data/models/event_details_model.dart';
import 'package:evetick/features/location/data/models/location_model.dart';

class EventDetailsData {
  const EventDetailsData({
    required this.event,
    this.coordinates,
    this.isFavorite = false,
    this.isFollowing = false,
  });

  final EventDetails event;

  final LocationModel? coordinates;
  final bool isFavorite;
  final bool isFollowing;

  EventDetailsData copyWith({
    EventDetails? event,
    LocationModel? coordinates,
    bool? isFavorite,
    bool? isFollowing,
  }) {
    return EventDetailsData(
      event: event ?? this.event,
      coordinates: coordinates ?? this.coordinates,
      isFavorite: isFavorite ?? this.isFavorite,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }
}
