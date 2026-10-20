import 'package:evetick/features/organizer_profile/data/models/organizer_profile_model.dart';

enum OrganizerProfileStatus { loading, success, error }

enum OrganizerProfileTab { upcoming, past, reviews }

class OrganizerProfileState {
  const OrganizerProfileState({
    this.status = OrganizerProfileStatus.loading,
    this.errorMessage,
    this.profile,
    this.isFollowing = false,
    this.canFollow = false,
    this.tab = OrganizerProfileTab.upcoming,
  });

  final OrganizerProfileStatus status;
  final String? errorMessage;
  final OrganizerProfile? profile;
  final bool isFollowing;

  /// False for guests and for the user's own organizer account.
  final bool canFollow;
  final OrganizerProfileTab tab;

  OrganizerProfileState copyWith({
    OrganizerProfileStatus? status,
    String? errorMessage,
    OrganizerProfile? profile,
    bool? isFollowing,
    bool? canFollow,
    OrganizerProfileTab? tab,
  }) {
    return OrganizerProfileState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      profile: profile ?? this.profile,
      isFollowing: isFollowing ?? this.isFollowing,
      canFollow: canFollow ?? this.canFollow,
      tab: tab ?? this.tab,
    );
  }
}
