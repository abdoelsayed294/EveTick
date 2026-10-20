import 'package:evetick/features/home/data/models/home_event_model.dart';

class OrganizerProfile {
  const OrganizerProfile({
    required this.id,
    required this.name,
    required this.followers,
    required this.eventsHosted,
    required this.upcomingEvents,
    required this.pastEvents,
    this.avatarUrl,
    this.bannerUrl,
    this.bio,
    this.isVerified = false,
  });

  final String id;
  final String name;
  final int followers;
  final int eventsHosted;
  final List<HomeEvent> upcomingEvents;
  final List<HomeEvent> pastEvents;
  final String? avatarUrl;

  
  final String? bannerUrl;
  final String? bio;
  final bool isVerified;

  OrganizerProfile copyWith({int? followers}) {
    return OrganizerProfile(
      id: id,
      name: name,
      followers: followers ?? this.followers,
      eventsHosted: eventsHosted,
      upcomingEvents: upcomingEvents,
      pastEvents: pastEvents,
      avatarUrl: avatarUrl,
      bannerUrl: bannerUrl,
      bio: bio,
      isVerified: isVerified,
    );
  }
}
