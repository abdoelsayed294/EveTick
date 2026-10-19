import 'dart:io';

import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/reviews/data/reviews_repository.dart';
import 'package:evetick/features/reviews/logic/write_review_cubit/write_review_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WriteReviewCubit extends Cubit<WriteReviewState<String>> {
  final ReviewsRepository reviewsRepo;
  WriteReviewCubit(this.reviewsRepo) : super(const WriteReviewState.initial());

  final reviewController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final rating = ValueNotifier<int>(0);
  final showRatingError = ValueNotifier<bool>(false);
  final isAnonymous = ValueNotifier<bool>(false);
  final photos = ValueNotifier<List<File>>(const []);

  void setRating(int value) {
    rating.value = value;
    showRatingError.value = false;
  }

  void setAnonymous(bool value) => isAnonymous.value = value;

  Future<void> pickPhoto() async {
    emit(const WriteReviewState.initial()); // clears an old error banner

    if (photos.value.length >= ReviewsRepository.maxPhotos) {
      emit(
        WriteReviewState.error(
          error: 'You can add up to ${ReviewsRepository.maxPhotos} photos',
        ),
      );
      return;
    }

    final result = await reviewsRepo.pickPhoto();
    await result.when(
      success: (file) async {
        if (file == null) return; // user cancelled
        if (!await reviewsRepo.isValidPhoto(file)) {
          emit(
            const WriteReviewState.error(
              error: 'Only PNG or JPG photos up to 5 MB are allowed',
            ),
          );
          return;
        }
        photos.value = [...photos.value, file];
      },
      failure: (failure) async {
        emit(WriteReviewState.error(error: failure.message));
      },
    );
  }

  void removePhoto(File file) {
    photos.value = photos.value.where((f) => f.path != file.path).toList();
  }

  void emitWriteReviewStates({required String eventId}) async {
    if (rating.value == 0) {
      showRatingError.value = true;
      return;
    }
    if (!formKey.currentState!.validate()) return;

    emit(const WriteReviewState.loading());
    final result = await reviewsRepo.postReview(
      eventId: eventId,
      rating: rating.value,
      text: reviewController.text.trim(),
      isAnonymous: isAnonymous.value,
      photos: photos.value,
    );
    if (isClosed) return;
    result.when(
      success: (reviewId) {
        emit(WriteReviewState.success(reviewId));
      },
      failure: (failure) {
        emit(WriteReviewState.error(error: failure.message));
      },
    );
  }

  @override
  Future<void> close() {
    reviewController.dispose();
    rating.dispose();
    showRatingError.dispose();
    isAnonymous.dispose();
    photos.dispose();
    return super.close();
  }
}
