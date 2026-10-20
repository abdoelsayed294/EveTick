// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reviews_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReviewsState<T> {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewsState<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ReviewsState<$T>()';
}


}

/// @nodoc
class $ReviewsStateCopyWith<T,$Res>  {
$ReviewsStateCopyWith(ReviewsState<T> _, $Res Function(ReviewsState<T>) __);
}


/// Adds pattern-matching-related methods to [ReviewsState].
extension ReviewsStatePatterns<T> on ReviewsState<T> {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial<T> value)?  initial,TResult Function( ReviewsLoading<T> value)?  loading,TResult Function( ReviewsSuccess<T> value)?  success,TResult Function( ReviewsError<T> value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case ReviewsLoading() when loading != null:
return loading(_that);case ReviewsSuccess() when success != null:
return success(_that);case ReviewsError() when error != null:
return error(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial<T> value)  initial,required TResult Function( ReviewsLoading<T> value)  loading,required TResult Function( ReviewsSuccess<T> value)  success,required TResult Function( ReviewsError<T> value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case ReviewsLoading():
return loading(_that);case ReviewsSuccess():
return success(_that);case ReviewsError():
return error(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial<T> value)?  initial,TResult? Function( ReviewsLoading<T> value)?  loading,TResult? Function( ReviewsSuccess<T> value)?  success,TResult? Function( ReviewsError<T> value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case ReviewsLoading() when loading != null:
return loading(_that);case ReviewsSuccess() when success != null:
return success(_that);case ReviewsError() when error != null:
return error(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( T data)?  success,TResult Function( String error)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case ReviewsLoading() when loading != null:
return loading();case ReviewsSuccess() when success != null:
return success(_that.data);case ReviewsError() when error != null:
return error(_that.error);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( T data)  success,required TResult Function( String error)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case ReviewsLoading():
return loading();case ReviewsSuccess():
return success(_that.data);case ReviewsError():
return error(_that.error);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( T data)?  success,TResult? Function( String error)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case ReviewsLoading() when loading != null:
return loading();case ReviewsSuccess() when success != null:
return success(_that.data);case ReviewsError() when error != null:
return error(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _Initial<T> implements ReviewsState<T> {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ReviewsState<$T>.initial()';
}


}




/// @nodoc


class ReviewsLoading<T> implements ReviewsState<T> {
  const ReviewsLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewsLoading<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ReviewsState<$T>.loading()';
}


}




/// @nodoc


class ReviewsSuccess<T> implements ReviewsState<T> {
  const ReviewsSuccess(this.data);
  

 final  T data;

/// Create a copy of ReviewsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewsSuccessCopyWith<T, ReviewsSuccess<T>> get copyWith => _$ReviewsSuccessCopyWithImpl<T, ReviewsSuccess<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewsSuccess<T>&&const DeepCollectionEquality().equals(other.data, data));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'ReviewsState<$T>.success(data: $data)';
}


}

/// @nodoc
abstract mixin class $ReviewsSuccessCopyWith<T,$Res> implements $ReviewsStateCopyWith<T, $Res> {
  factory $ReviewsSuccessCopyWith(ReviewsSuccess<T> value, $Res Function(ReviewsSuccess<T>) _then) = _$ReviewsSuccessCopyWithImpl;
@useResult
$Res call({
 T data
});




}
/// @nodoc
class _$ReviewsSuccessCopyWithImpl<T,$Res>
    implements $ReviewsSuccessCopyWith<T, $Res> {
  _$ReviewsSuccessCopyWithImpl(this._self, this._then);

  final ReviewsSuccess<T> _self;
  final $Res Function(ReviewsSuccess<T>) _then;

/// Create a copy of ReviewsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = freezed,}) {
  return _then(ReviewsSuccess<T>(
freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T,
  ));
}


}

/// @nodoc


class ReviewsError<T> implements ReviewsState<T> {
  const ReviewsError({required this.error});
  

 final  String error;

/// Create a copy of ReviewsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewsErrorCopyWith<T, ReviewsError<T>> get copyWith => _$ReviewsErrorCopyWithImpl<T, ReviewsError<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewsError<T>&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'ReviewsState<$T>.error(error: $error)';
}


}

/// @nodoc
abstract mixin class $ReviewsErrorCopyWith<T,$Res> implements $ReviewsStateCopyWith<T, $Res> {
  factory $ReviewsErrorCopyWith(ReviewsError<T> value, $Res Function(ReviewsError<T>) _then) = _$ReviewsErrorCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class _$ReviewsErrorCopyWithImpl<T,$Res>
    implements $ReviewsErrorCopyWith<T, $Res> {
  _$ReviewsErrorCopyWithImpl(this._self, this._then);

  final ReviewsError<T> _self;
  final $Res Function(ReviewsError<T>) _then;

/// Create a copy of ReviewsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(ReviewsError<T>(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
