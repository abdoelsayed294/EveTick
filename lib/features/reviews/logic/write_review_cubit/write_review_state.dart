import 'package:freezed_annotation/freezed_annotation.dart';

part 'write_review_state.freezed.dart';

@freezed
class WriteReviewState<T> with _$WriteReviewState<T> {
  const factory WriteReviewState.initial() = _Initial;
  const factory WriteReviewState.loading() = WriteReviewLoading;
  const factory WriteReviewState.success(T data) = WriteReviewSuccess<T>;
  const factory WriteReviewState.error({required String error}) =
      WriteReviewError;
}
