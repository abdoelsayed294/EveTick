class OrganizerReview {
  const OrganizerReview({
    required this.id,
    required this.organizerId,
    required this.reviewerId,
    required this.authorName,
    required this.isAnonymous,
    required this.rating,
    required this.text,
    required this.verified,
    required this.isMine,
    this.authorImageUrl,
    this.createdAt,
  });

  final String id;
  final String organizerId;
  final String reviewerId;
  final String authorName;
  final String? authorImageUrl;
  final bool isAnonymous;
  final int rating;
  final String text;
  final bool verified;
  final DateTime? createdAt;

  final bool isMine;

  factory OrganizerReview.fromJson(
    Map<String, dynamic> json, {
    required String currentUserId,
  }) {
    final imageUrl = json['authorImageUrl'] as String?;
    final reviewerId = json['reviewerId'] as String? ?? '';

    return OrganizerReview(
      id: json['reviewId'] as String,
      organizerId: json['organizerId'] as String? ?? '',
      reviewerId: reviewerId,
      authorName: json['authorName'] as String? ?? 'Anonymous',
      authorImageUrl: (imageUrl == null || imageUrl.isEmpty) ? null : imageUrl,
      isAnonymous: json['isAnonymous'] as bool? ?? false,
      rating: ((json['rating'] as num?)?.toInt() ?? 0).clamp(0, 5).toInt(),
      text: json['text'] as String? ?? '',
      verified: json['verified'] as bool? ?? true,
      createdAt: json['createdAt'] as DateTime?,
      isMine: reviewerId == currentUserId,
    );
  }
}
