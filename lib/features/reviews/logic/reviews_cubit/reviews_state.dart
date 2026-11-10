import 'package:freezed_annotation/freezed_annotation.dart';

part 'reviews_state.freezed.dart';

@freezed
class ReviewsState<T> with _$ReviewsState<T> {
  const factory ReviewsState.initial() = _Initial;
  const factory ReviewsState.loading() = ReviewsLoading;
  const factory ReviewsState.success(T data) = ReviewsSuccess<T>;
  const factory ReviewsState.error({required String error}) = ReviewsError;
}
