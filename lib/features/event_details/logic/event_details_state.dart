import 'package:evetick/features/event_details/data/models/event_details_model.dart';
import 'package:evetick/features/location/data/models/location_model.dart';

enum EventDetailsStatus { loading, success, error }

class EventDetailsState {
  const EventDetailsState({
    this.status = EventDetailsStatus.loading,
    this.errorMessage,
    this.event,
    this.coordinates,
    this.isFavorite = false,
    this.isFollowing = false,
  });

  final EventDetailsStatus status;
  final String? errorMessage;
  final EventDetails? event;

  /// Resolved after the page is already visible; null = no map.
  final LocationModel? coordinates;
  final bool isFavorite;
  final bool isFollowing;

  EventDetailsState copyWith({
    EventDetailsStatus? status,
    String? errorMessage,
    EventDetails? event,
    LocationModel? coordinates,
    bool? isFavorite,
    bool? isFollowing,
  }) {
    return EventDetailsState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      event: event ?? this.event,
      coordinates: coordinates ?? this.coordinates,
      isFavorite: isFavorite ?? this.isFavorite,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }
}
