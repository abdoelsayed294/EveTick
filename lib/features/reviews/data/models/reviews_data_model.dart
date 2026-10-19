import 'package:evetick/features/reviews/data/models/review_eligibility_model.dart';
import 'package:evetick/features/reviews/data/models/review_model.dart';
import 'package:evetick/features/reviews/data/models/review_summary_model.dart';

/// Everything the reviews screen shows (the `T` of `ReviewsState<T>`).
class ReviewsData {
  const ReviewsData({
    required this.summary,
    required this.reviews,
    required this.hasMore,
    required this.eligibility,
    this.cursor,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  final ReviewSummary summary;
  final List<Review> reviews;
  final bool hasMore;
  final ReviewEligibility eligibility;
  final Object? cursor;
  final bool isLoadingMore;
  final String? loadMoreError;

  ReviewsData copyWith({
    List<Review>? reviews,
    bool? hasMore,
    Object? cursor,
    bool? isLoadingMore,
    String? loadMoreError,
    bool clearLoadMoreError = false,
  }) {
    return ReviewsData(
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
