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

  String get followersText {
    if (followers >= 1000000) {
      return '${(followers / 1000000).toStringAsFixed(1)}M';
    }
    if (followers >= 1000) return '${(followers / 1000).toStringAsFixed(1)}k';
    return '$followers';
  }
}
