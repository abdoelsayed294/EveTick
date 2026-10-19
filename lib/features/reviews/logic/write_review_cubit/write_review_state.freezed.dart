// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'write_review_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WriteReviewState<T> {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WriteReviewState<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'WriteReviewState<$T>()';
}


}

/// @nodoc
class $WriteReviewStateCopyWith<T,$Res>  {
$WriteReviewStateCopyWith(WriteReviewState<T> _, $Res Function(WriteReviewState<T>) __);
}


/// Adds pattern-matching-related methods to [WriteReviewState].
extension WriteReviewStatePatterns<T> on WriteReviewState<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial<T> value)?  initial,TResult Function( WriteReviewLoading<T> value)?  loading,TResult Function( WriteReviewSuccess<T> value)?  success,TResult Function( WriteReviewError<T> value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case WriteReviewLoading() when loading != null:
return loading(_that);case WriteReviewSuccess() when success != null:
return success(_that);case WriteReviewError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial<T> value)  initial,required TResult Function( WriteReviewLoading<T> value)  loading,required TResult Function( WriteReviewSuccess<T> value)  success,required TResult Function( WriteReviewError<T> value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case WriteReviewLoading():
return loading(_that);case WriteReviewSuccess():
return success(_that);case WriteReviewError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial<T> value)?  initial,TResult? Function( WriteReviewLoading<T> value)?  loading,TResult? Function( WriteReviewSuccess<T> value)?  success,TResult? Function( WriteReviewError<T> value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case WriteReviewLoading() when loading != null:
return loading(_that);case WriteReviewSuccess() when success != null:
return success(_that);case WriteReviewError() when error != null:
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
return initial();case WriteReviewLoading() when loading != null:
return loading();case WriteReviewSuccess() when success != null:
return success(_that.data);case WriteReviewError() when error != null:
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
return initial();case WriteReviewLoading():
return loading();case WriteReviewSuccess():
return success(_that.data);case WriteReviewError():
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
return initial();case WriteReviewLoading() when loading != null:
return loading();case WriteReviewSuccess() when success != null:
return success(_that.data);case WriteReviewError() when error != null:
return error(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _Initial<T> implements WriteReviewState<T> {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'WriteReviewState<$T>.initial()';
}


}




/// @nodoc


class WriteReviewLoading<T> implements WriteReviewState<T> {
  const WriteReviewLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WriteReviewLoading<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'WriteReviewState<$T>.loading()';
}


}




/// @nodoc


class WriteReviewSuccess<T> implements WriteReviewState<T> {
  const WriteReviewSuccess(this.data);
  

 final  T data;

/// Create a copy of WriteReviewState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WriteReviewSuccessCopyWith<T, WriteReviewSuccess<T>> get copyWith => _$WriteReviewSuccessCopyWithImpl<T, WriteReviewSuccess<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WriteReviewSuccess<T>&&const DeepCollectionEquality().equals(other.data, data));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'WriteReviewState<$T>.success(data: $data)';
}


}

/// @nodoc
abstract mixin class $WriteReviewSuccessCopyWith<T,$Res> implements $WriteReviewStateCopyWith<T, $Res> {
  factory $WriteReviewSuccessCopyWith(WriteReviewSuccess<T> value, $Res Function(WriteReviewSuccess<T>) _then) = _$WriteReviewSuccessCopyWithImpl;
@useResult
$Res call({
 T data
});




}
/// @nodoc
class _$WriteReviewSuccessCopyWithImpl<T,$Res>
    implements $WriteReviewSuccessCopyWith<T, $Res> {
  _$WriteReviewSuccessCopyWithImpl(this._self, this._then);

  final WriteReviewSuccess<T> _self;
  final $Res Function(WriteReviewSuccess<T>) _then;

/// Create a copy of WriteReviewState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = freezed,}) {
  return _then(WriteReviewSuccess<T>(
freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T,
  ));
}


}

/// @nodoc


class WriteReviewError<T> implements WriteReviewState<T> {
  const WriteReviewError({required this.error});
  

 final  String error;

/// Create a copy of WriteReviewState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WriteReviewErrorCopyWith<T, WriteReviewError<T>> get copyWith => _$WriteReviewErrorCopyWithImpl<T, WriteReviewError<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WriteReviewError<T>&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'WriteReviewState<$T>.error(error: $error)';
}


}

/// @nodoc
abstract mixin class $WriteReviewErrorCopyWith<T,$Res> implements $WriteReviewStateCopyWith<T, $Res> {
  factory $WriteReviewErrorCopyWith(WriteReviewError<T> value, $Res Function(WriteReviewError<T>) _then) = _$WriteReviewErrorCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class _$WriteReviewErrorCopyWithImpl<T,$Res>
    implements $WriteReviewErrorCopyWith<T, $Res> {
  _$WriteReviewErrorCopyWithImpl(this._self, this._then);

  final WriteReviewError<T> _self;
  final $Res Function(WriteReviewError<T>) _then;

/// Create a copy of WriteReviewState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(WriteReviewError<T>(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
