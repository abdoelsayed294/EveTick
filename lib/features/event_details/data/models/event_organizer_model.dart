/// Organizer shown on the landing page.
/// Optional: add `organizerName`, `organizerAvatarUrl` and
/// `organizerFollowers` to `events/{id}` and the section shows up.
class EventOrganizer {
  const EventOrganizer({
    required this.name,
    this.avatarUrl,
    this.followers = 0,
  });

  final String name;
  final String? avatarUrl;
  final int followers;

  /// 12400 -> "12.4k"
  String get followersText {
    if (followers >= 1000000) {
      return '${(followers / 1000000).toStringAsFixed(1)}M';
    }
    if (followers >= 1000) return '${(followers / 1000).toStringAsFixed(1)}k';
    return '$followers';
  }
}
