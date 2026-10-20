import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/organizer_reviews/data/organizer_reviews_repository.dart';
import 'package:evetick/features/reviews/data/reviews_repository.dart';
import 'package:evetick/features/reviews/logic/write_review_cubit/write_review_cubit.dart';
import 'package:evetick/features/reviews/logic/write_review_cubit/write_review_state.dart';

/// "Write a Review" for an organizer.
///
/// It extends [WriteReviewCubit] so the star input, the text field, the
/// anonymous switch and `WriteReviewBlocListener` of the event reviews work
/// unchanged: the router provides it as a `WriteReviewCubit`. It keeps the
/// same controller / formKey / rating / anonymous state; photos are not used.
class WriteOrganizerReviewCubit extends WriteReviewCubit {
  final OrganizerReviewsRepository organizerReviewsRepo;

  WriteOrganizerReviewCubit(
    ReviewsRepository reviewsRepo,
    this.organizerReviewsRepo,
  ) : super(reviewsRepo);

  Future<void> postOrganizerReview({required String organizerId}) async {
    if (rating.value == 0) {
      showRatingError.value = true;
      return;
    }
    if (!formKey.currentState!.validate()) return;

    emit(const WriteReviewState.loading());
    final result = await organizerReviewsRepo.postReview(
      organizerId: organizerId,
      rating: rating.value,
      text: reviewController.text.trim(),
      isAnonymous: isAnonymous.value,
    );
    if (isClosed) return;
    result.when(
      success: (reviewId) => emit(WriteReviewState.success(reviewId)),
      failure: (failure) => emit(WriteReviewState.error(error: failure.message)),
    );
  }
}
