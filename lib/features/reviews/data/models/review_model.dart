/// One review: `events/{eventId}/reviews/{userId}`.
///
/// {
///   reviewId, eventId, userId, authorName, authorImageUrl, isAnonymous,
///   rating (1-5), text, photoUrls: [...], verified, helpfulCount, createdAt
/// }
///
/// When the author posts anonymously, the real name and photo are never
/// saved in the document ([authorName] is "Anonymous").
class Review {
  const Review({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.authorName,
    required this.isAnonymous,
    required this.rating,
    required this.text,
    required this.photoUrls,
    required this.verified,
    required this.helpfulCount,
    required this.isHelpful,
    required this.isMine,
    this.authorImageUrl,
    this.createdAt,
  });

  final String id;
  final String eventId;
  final String userId;
  final String authorName;
  final String? authorImageUrl;
  final bool isAnonymous;
  final int rating;
  final String text;
  final List<String> photoUrls;
  final bool verified;
  final int helpfulCount;
  final DateTime? createdAt;

  /// The signed-in user marked this review as helpful.
  final bool isHelpful;

  /// Written by the signed-in user.
  final bool isMine;

  /// [json] is the document data plus `reviewId` and a `createdAt` that is
  /// already a [DateTime] (null while the server timestamp is pending).
  factory Review.fromJson(
    Map<String, dynamic> json, {
    required String currentUserId,
    required Set<String> helpfulKeys,
  }) {
    final id = json['reviewId'] as String;
    final eventId = json['eventId'] as String? ?? '';
    final userId = json['userId'] as String? ?? '';
    final imageUrl = json['authorImageUrl'] as String?;

    return Review(
      id: id,
      eventId: eventId,
      userId: userId,
      authorName: json['authorName'] as String? ?? 'Anonymous',
      authorImageUrl: (imageUrl == null || imageUrl.isEmpty) ? null : imageUrl,
      isAnonymous: json['isAnonymous'] as bool? ?? false,
      rating: ((json['rating'] as num?)?.toInt() ?? 0).clamp(0, 5).toInt(),
      text: json['text'] as String? ?? '',
      photoUrls: (json['photoUrls'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      verified: json['verified'] as bool? ?? true,
      helpfulCount: (json['helpfulCount'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] as DateTime?,
      isHelpful: helpfulKeys.contains(helpfulKey(eventId, id)),
      isMine: userId == currentUserId,
    );
  }

  /// Key saved in `users/{uid}.helpfulReviewKeys` when the user taps Helpful.
  static String helpfulKey(String eventId, String reviewId) =>
      '${eventId}_$reviewId';

  Review copyWith({int? helpfulCount, bool? isHelpful}) {
    return Review(
      id: id,
      eventId: eventId,
      userId: userId,
      authorName: authorName,
      authorImageUrl: authorImageUrl,
      isAnonymous: isAnonymous,
      rating: rating,
      text: text,
      photoUrls: photoUrls,
      verified: verified,
      helpfulCount: helpfulCount ?? this.helpfulCount,
      createdAt: createdAt,
      isHelpful: isHelpful ?? this.isHelpful,
      isMine: isMine,
    );
  }
}
