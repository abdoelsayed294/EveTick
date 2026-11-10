import 'package:evetick/features/reviews/data/models/review_model.dart';

class ReviewsPage {
  const ReviewsPage({
    required this.reviews,
    required this.hasMore,
    this.cursor,
  });

  final List<Review> reviews;
  final bool hasMore;

  final Object? cursor;
}
