import 'package:evetick/features/home/data/models/home_event_model.dart';

enum FavoritesStatus { loading, success, error }

class FavoritesState {
  const FavoritesState({
    this.status = FavoritesStatus.loading,
    this.errorMessage,
    this.events = const [],
  });

  final FavoritesStatus status;
  final String? errorMessage;
  final List<HomeEvent> events;

  FavoritesState copyWith({
    FavoritesStatus? status,
    String? errorMessage,
    List<HomeEvent>? events,
  }) {
    return FavoritesState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      events: events ?? this.events,
    );
  }
}
