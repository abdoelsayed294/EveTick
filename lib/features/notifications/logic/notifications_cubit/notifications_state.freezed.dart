// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notifications_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NotificationsState<T> {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationsState<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationsState<$T>()';
}


}

/// @nodoc
class $NotificationsStateCopyWith<T,$Res>  {
$NotificationsStateCopyWith(NotificationsState<T> _, $Res Function(NotificationsState<T>) __);
}


/// Adds pattern-matching-related methods to [NotificationsState].
extension NotificationsStatePatterns<T> on NotificationsState<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial<T> value)?  initial,TResult Function( NotificationsLoading<T> value)?  loading,TResult Function( NotificationsSuccess<T> value)?  success,TResult Function( NotificationsError<T> value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case NotificationsLoading() when loading != null:
return loading(_that);case NotificationsSuccess() when success != null:
return success(_that);case NotificationsError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial<T> value)  initial,required TResult Function( NotificationsLoading<T> value)  loading,required TResult Function( NotificationsSuccess<T> value)  success,required TResult Function( NotificationsError<T> value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case NotificationsLoading():
return loading(_that);case NotificationsSuccess():
return success(_that);case NotificationsError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial<T> value)?  initial,TResult? Function( NotificationsLoading<T> value)?  loading,TResult? Function( NotificationsSuccess<T> value)?  success,TResult? Function( NotificationsError<T> value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case NotificationsLoading() when loading != null:
return loading(_that);case NotificationsSuccess() when success != null:
return success(_that);case NotificationsError() when error != null:
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
return initial();case NotificationsLoading() when loading != null:
return loading();case NotificationsSuccess() when success != null:
return success(_that.data);case NotificationsError() when error != null:
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
return initial();case NotificationsLoading():
return loading();case NotificationsSuccess():
return success(_that.data);case NotificationsError():
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
return initial();case NotificationsLoading() when loading != null:
return loading();case NotificationsSuccess() when success != null:
return success(_that.data);case NotificationsError() when error != null:
return error(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _Initial<T> implements NotificationsState<T> {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationsState<$T>.initial()';
}


}




/// @nodoc


class NotificationsLoading<T> implements NotificationsState<T> {
  const NotificationsLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationsLoading<T>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NotificationsState<$T>.loading()';
}


}




/// @nodoc


class NotificationsSuccess<T> implements NotificationsState<T> {
  const NotificationsSuccess(this.data);
  

 final  T data;

/// Create a copy of NotificationsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationsSuccessCopyWith<T, NotificationsSuccess<T>> get copyWith => _$NotificationsSuccessCopyWithImpl<T, NotificationsSuccess<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationsSuccess<T>&&const DeepCollectionEquality().equals(other.data, data));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'NotificationsState<$T>.success(data: $data)';
}


}

/// @nodoc
abstract mixin class $NotificationsSuccessCopyWith<T,$Res> implements $NotificationsStateCopyWith<T, $Res> {
  factory $NotificationsSuccessCopyWith(NotificationsSuccess<T> value, $Res Function(NotificationsSuccess<T>) _then) = _$NotificationsSuccessCopyWithImpl;
@useResult
$Res call({
 T data
});




}
/// @nodoc
class _$NotificationsSuccessCopyWithImpl<T,$Res>
    implements $NotificationsSuccessCopyWith<T, $Res> {
  _$NotificationsSuccessCopyWithImpl(this._self, this._then);

  final NotificationsSuccess<T> _self;
  final $Res Function(NotificationsSuccess<T>) _then;

/// Create a copy of NotificationsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = freezed,}) {
  return _then(NotificationsSuccess<T>(
freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as T,
  ));
}


}

/// @nodoc


class NotificationsError<T> implements NotificationsState<T> {
  const NotificationsError({required this.error});
  

 final  String error;

/// Create a copy of NotificationsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationsErrorCopyWith<T, NotificationsError<T>> get copyWith => _$NotificationsErrorCopyWithImpl<T, NotificationsError<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationsError<T>&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'NotificationsState<$T>.error(error: $error)';
}


}

/// @nodoc
abstract mixin class $NotificationsErrorCopyWith<T,$Res> implements $NotificationsStateCopyWith<T, $Res> {
  factory $NotificationsErrorCopyWith(NotificationsError<T> value, $Res Function(NotificationsError<T>) _then) = _$NotificationsErrorCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class _$NotificationsErrorCopyWithImpl<T,$Res>
    implements $NotificationsErrorCopyWith<T, $Res> {
  _$NotificationsErrorCopyWithImpl(this._self, this._then);

  final NotificationsError<T> _self;
  final $Res Function(NotificationsError<T>) _then;

/// Create a copy of NotificationsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(NotificationsError<T>(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
