import 'package:evetick/features/following_organizers/data/models/followed_organizer_model.dart';

enum FollowingOrganizersStatus { loading, success, error }

class FollowingOrganizersState {
  const FollowingOrganizersState({
    this.status = FollowingOrganizersStatus.loading,
    this.errorMessage,
    this.organizers = const [],
    this.query = '',
  });

  final FollowingOrganizersStatus status;
  final String? errorMessage;
  final List<FollowedOrganizer> organizers;
  final String query;

  /// Organizers matching the search box.
  List<FollowedOrganizer> get visible {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return organizers;
    return organizers.where((o) => o.name.toLowerCase().contains(q)).toList();
  }

  FollowingOrganizersState copyWith({
    FollowingOrganizersStatus? status,
    String? errorMessage,
    List<FollowedOrganizer>? organizers,
    String? query,
  }) {
    return FollowingOrganizersState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      organizers: organizers ?? this.organizers,
      query: query ?? this.query,
    );
  }
}
