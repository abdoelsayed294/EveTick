/// Organizer shown on the landing page.
/// Loaded from `users/{organizerId}` (the event only stores `organizerId`).
/// An event can still override it with `organizerName`,
/// `organizerAvatarUrl` and `organizerFollowers`.
class EventOrganizer {
  const EventOrganizer({
    required this.name,
    this.avatarUrl,
    this.followers = 0,
  });

  final String name;
  final String? avatarUrl;
  final int followers;

  EventOrganizer copyWith({int? followers}) => EventOrganizer(
        name: name,
        avatarUrl: avatarUrl,
        followers: followers ?? this.followers,
      );

  /// Builds the organizer from a `users/{uid}` document.
  /// Returns null when the account has no usable name.
  static EventOrganizer? fromUser(Map<String, dynamic> json) {
    final name = ((json['name'] as String?) ?? '').trim();
    if (name.isEmpty) return null;
    final image = (json['imageUrl'] as String?)?.trim();
    return EventOrganizer(
      name: name,
      avatarUrl: (image == null || image.isEmpty) ? null : image,
      followers: (json['followers'] as num?)?.toInt() ?? 0,
    );
  }

  /// 12400 -> "12.4k"
  String get followersText {
    if (followers >= 1000000) {
      return '${(followers / 1000000).toStringAsFixed(1)}M';
    }
    if (followers >= 1000) return '${(followers / 1000).toStringAsFixed(1)}k';
    return '$followers';
  }
}
