import 'package:evetick/features/organizer_profile/data/models/organizer_profile_model.dart';
import 'package:evetick/features/organizer_profile/logic/organizer_profile_tab.dart';
import 'package:evetick/features/organizer_profile/ui/widgets/organizer_events_list.dart';
import 'package:evetick/features/organizer_reviews/ui/widgets/organizer_reviews_tab.dart';
import 'package:flutter/material.dart';

class OrganizerTabContent extends StatelessWidget {
  const OrganizerTabContent({
    super.key,
    required this.tab,
    required this.profile,
  });

  final OrganizerProfileTab tab;
  final OrganizerProfile profile;

  @override
  Widget build(BuildContext context) {
    switch (tab) {
      case OrganizerProfileTab.upcoming:
        return OrganizerEventsList(
          events: profile.upcomingEvents,
          emptyMessage: 'No upcoming events',
        );
      case OrganizerProfileTab.past:
        return OrganizerEventsList(
          events: profile.pastEvents,
          emptyMessage: 'No past events',
        );
      case OrganizerProfileTab.reviews:
        return OrganizerReviewsTab(organizerId: profile.id);
    }
  }
}
