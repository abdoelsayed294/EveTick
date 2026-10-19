import 'package:evetick/features/organizer_reviews/data/models/organizer_review_eligibility_model.dart';
import 'package:evetick/features/organizer_reviews/data/models/organizer_review_model.dart';
import 'package:evetick/features/reviews/data/models/review_summary_model.dart';

/// Everything the organizer "Reviews" tab shows (the `T` of
/// `ReviewsState<T>`).
class OrganizerReviewsData {
  const OrganizerReviewsData({
    required this.summary,
    required this.reviews,
    required this.hasMore,
    required this.eligibility,
    this.cursor,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  final ReviewSummary summary;
  final List<OrganizerReview> reviews;
  final bool hasMore;
  final OrganizerReviewEligibility eligibility;
  final Object? cursor;
  final bool isLoadingMore;
  final String? loadMoreError;

  OrganizerReviewsData copyWith({
    List<OrganizerReview>? reviews,
    bool? hasMore,
    Object? cursor,
    bool? isLoadingMore,
    String? loadMoreError,
    bool clearLoadMoreError = false,
  }) {
    return OrganizerReviewsData(
      summary: summary,
      reviews: reviews ?? this.reviews,
      hasMore: hasMore ?? this.hasMore,
      eligibility: eligibility,
      cursor: cursor ?? this.cursor,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreError:
          clearLoadMoreError ? null : (loadMoreError ?? this.loadMoreError),
    );
  }
}

/// One page of organizer reviews and where the next one starts.
class OrganizerReviewsPage {
  const OrganizerReviewsPage({
    required this.reviews,
    required this.hasMore,
    this.cursor,
  });

  final List<OrganizerReview> reviews;
  final bool hasMore;

  /// Opaque position of the last review (a Firestore document snapshot).
  final Object? cursor;
}
