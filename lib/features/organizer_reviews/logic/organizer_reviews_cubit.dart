import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/organizer_reviews/data/models/organizer_reviews_data_model.dart';
import 'package:evetick/features/organizer_reviews/data/organizer_reviews_repository.dart';
import 'package:evetick/features/reviews/logic/reviews_cubit/reviews_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrganizerReviewsCubit extends Cubit<ReviewsState<OrganizerReviewsData>> {
  final OrganizerReviewsRepository repo;
  OrganizerReviewsCubit(this.repo) : super(const ReviewsState.initial());

  String _organizerId = '';

  OrganizerReviewsData? get _data => state.whenOrNull(success: (data) => data);

  Future<void> load({
    required String organizerId,
    bool silent = false,
    bool force = false,
  }) async {
    if (!force && _organizerId == organizerId) return;
    _organizerId = organizerId;
    if (!silent) emit(const ReviewsState.loading());

    final result = await repo.getReviews(organizerId: organizerId);
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

    final result = await repo.getMoreReviews(
      organizerId: _organizerId,
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
}
