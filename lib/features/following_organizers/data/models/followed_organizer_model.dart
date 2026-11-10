class FollowedOrganizer {
  const FollowedOrganizer({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.followers = 0,
    this.isFollowing = true,
  });

  final String id;
  final String name;
  final String? avatarUrl;
  final int followers;
  final bool isFollowing;

  static FollowedOrganizer? fromUser(String id, Map<String, dynamic> json) {
    final name = ((json['name'] as String?) ?? '').trim();
    if (name.isEmpty) return null;
    final image = (json['imageUrl'] as String?)?.trim();
    return FollowedOrganizer(
      id: id,
      name: name,
      avatarUrl: (image == null || image.isEmpty) ? null : image,
      followers: (json['followers'] as num?)?.toInt() ?? 0,
    );
  }

  FollowedOrganizer copyWith({int? followers, bool? isFollowing}) {
    return FollowedOrganizer(
      id: id,
      name: name,
      avatarUrl: avatarUrl,
      followers: followers ?? this.followers,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }
}
