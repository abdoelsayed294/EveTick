import 'package:evetick/features/reviews/data/models/review_model.dart';

/// One page of reviews and where the next one starts.
class ReviewsPage {
  const ReviewsPage({
    required this.reviews,
    required this.hasMore,
    this.cursor,
  });

  final List<Review> reviews;
  final bool hasMore;

  /// Opaque position of the last review (a Firestore document snapshot).
  final Object? cursor;
}
