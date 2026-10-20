import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorites_state.freezed.dart';

@freezed
class FavoritesState<T> with _$FavoritesState<T> {
  const factory FavoritesState.initial() = _Initial;
  const factory FavoritesState.loading() = Loading;
  const factory FavoritesState.success(T data) = Success<T>;
  const factory FavoritesState.error({required String error}) = Error;
}
