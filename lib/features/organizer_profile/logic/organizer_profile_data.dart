import 'package:evetick/features/organizer_profile/data/models/organizer_profile_model.dart';
import 'package:evetick/features/organizer_profile/logic/organizer_profile_tab.dart';

class OrganizerProfileData {
  const OrganizerProfileData({
    required this.profile,
    this.isFollowing = false,
    this.canFollow = false,
    this.tab = OrganizerProfileTab.upcoming,
  });

  final OrganizerProfile profile;
  final bool isFollowing;

  final bool canFollow;
  final OrganizerProfileTab tab;

  OrganizerProfileData copyWith({
    OrganizerProfile? profile,
    bool? isFollowing,
    bool? canFollow,
    OrganizerProfileTab? tab,
  }) {
    return OrganizerProfileData(
      profile: profile ?? this.profile,
      isFollowing: isFollowing ?? this.isFollowing,
      canFollow: canFollow ?? this.canFollow,
      tab: tab ?? this.tab,
    );
  }
}
