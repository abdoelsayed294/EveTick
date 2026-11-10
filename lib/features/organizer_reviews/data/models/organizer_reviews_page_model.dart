import 'package:evetick/features/organizer_reviews/data/models/organizer_review_model.dart';

class OrganizerReviewsPage {
  const OrganizerReviewsPage({
    required this.reviews,
    required this.hasMore,
    this.cursor,
  });

  final List<OrganizerReview> reviews;
  final bool hasMore;

  final Object? cursor;
}
