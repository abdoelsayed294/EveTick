import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/reviews/data/models/review_model.dart';
import 'package:evetick/features/reviews/data/models/reviews_data_model.dart';
import 'package:evetick/features/reviews/data/reviews_repository.dart';
import 'package:evetick/features/reviews/logic/reviews_cubit/reviews_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReviewsCubit extends Cubit<ReviewsState<ReviewsData>> {
  final ReviewsRepository reviewsRepo;
  ReviewsCubit(this.reviewsRepo) : super(const ReviewsState.initial());

  String _eventId = '';

  ReviewsData? get _data => state.whenOrNull(success: (data) => data);

  Future<void> emitReviewsStates({
    required String eventId,
    bool silent = false,
  }) async {
    _eventId = eventId;
    if (!silent) emit(const ReviewsState.loading());

    final result = await reviewsRepo.getReviews(eventId: eventId);
    if (isClosed) return;
    result.when(
      success: (data) => emit(ReviewsState.success(data)),
      failure: (failure) {
        if (silent && _data != null) return;
        emit(ReviewsState.error(error: failure.message));
      },
    );
  }

  Future<void> loadMore() async {
    final data = _data;
    if (data == null || !data.hasMore || data.isLoadingMore) return;

    emit(
      ReviewsState.success(
        data.copyWith(isLoadingMore: true, clearLoadMoreError: true),
      ),
    );

    final result = await reviewsRepo.getMoreReviews(
      eventId: _eventId,
      cursor: data.cursor,
    );
    if (isClosed) return;

    final current = _data ?? data;
    result.when(
      success: (page) => emit(
        ReviewsState.success(
          current.copyWith(
            reviews: [...current.reviews, ...page.reviews],
            hasMore: page.hasMore,
            cursor: page.cursor,
            isLoadingMore: false,
          ),
        ),
      ),
      failure: (failure) => emit(
        ReviewsState.success(
          current.copyWith(
            isLoadingMore: false,
            loadMoreError: failure.message,
          ),
        ),
      ),
    );
  }

  Future<void> toggleHelpful(String reviewId) async {
    final before = _findReview(reviewId);
    if (before == null || before.isMine) return;

    final nowHelpful = !before.isHelpful;
    final count = before.helpfulCount + (nowHelpful ? 1 : -1);
    _replaceReview(
      before.copyWith(
        isHelpful: nowHelpful,
        helpfulCount: count < 0 ? 0 : count,
      ),
    );

    final result = await reviewsRepo.setHelpful(
      eventId: _eventId,
      reviewId: reviewId,
      helpful: nowHelpful,
    );
    if (isClosed) return;
    result.when(
      success: (_) {},
      failure: (_) => _replaceReview(before),
    );
  }

  Review? _findReview(String reviewId) {
    final data = _data;
    if (data == null) return null;
    for (final review in data.reviews) {
      if (review.id == reviewId) return review;
    }
    return null;
  }

  void _replaceReview(Review updated) {
    final data = _data;
    if (data == null) return;
    emit(
      ReviewsState.success(
        data.copyWith(
          reviews: [
            for (final r in data.reviews) r.id == updated.id ? updated : r,
          ],
        ),
      ),
    );
  }
}
