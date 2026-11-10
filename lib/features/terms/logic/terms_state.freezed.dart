// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'terms_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TermsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TermsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TermsState()';
}


}

/// @nodoc
class $TermsStateCopyWith<$Res>  {
$TermsStateCopyWith(TermsState _, $Res Function(TermsState) __);
}


/// Adds pattern-matching-related methods to [TermsState].
extension TermsStatePatterns on TermsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( TermsLoading value)?  loading,TResult Function( TermsLoaded value)?  loaded,TResult Function( TermsSaving value)?  saving,TResult Function( TermsSaved value)?  saved,TResult Function( TermsError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case TermsLoading() when loading != null:
return loading(_that);case TermsLoaded() when loaded != null:
return loaded(_that);case TermsSaving() when saving != null:
return saving(_that);case TermsSaved() when saved != null:
return saved(_that);case TermsError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( TermsLoading value)  loading,required TResult Function( TermsLoaded value)  loaded,required TResult Function( TermsSaving value)  saving,required TResult Function( TermsSaved value)  saved,required TResult Function( TermsError value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case TermsLoading():
return loading(_that);case TermsLoaded():
return loaded(_that);case TermsSaving():
return saving(_that);case TermsSaved():
return saved(_that);case TermsError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( TermsLoading value)?  loading,TResult? Function( TermsLoaded value)?  loaded,TResult? Function( TermsSaving value)?  saving,TResult? Function( TermsSaved value)?  saved,TResult? Function( TermsError value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case TermsLoading() when loading != null:
return loading(_that);case TermsLoaded() when loaded != null:
return loaded(_that);case TermsSaving() when saving != null:
return saving(_that);case TermsSaved() when saved != null:
return saved(_that);case TermsError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( TermsAcceptanceModel acceptance)?  loaded,TResult Function()?  saving,TResult Function()?  saved,TResult Function( String error)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case TermsLoading() when loading != null:
return loading();case TermsLoaded() when loaded != null:
return loaded(_that.acceptance);case TermsSaving() when saving != null:
return saving();case TermsSaved() when saved != null:
return saved();case TermsError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( TermsAcceptanceModel acceptance)  loaded,required TResult Function()  saving,required TResult Function()  saved,required TResult Function( String error)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case TermsLoading():
return loading();case TermsLoaded():
return loaded(_that.acceptance);case TermsSaving():
return saving();case TermsSaved():
return saved();case TermsError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( TermsAcceptanceModel acceptance)?  loaded,TResult? Function()?  saving,TResult? Function()?  saved,TResult? Function( String error)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case TermsLoading() when loading != null:
return loading();case TermsLoaded() when loaded != null:
return loaded(_that.acceptance);case TermsSaving() when saving != null:
return saving();case TermsSaved() when saved != null:
return saved();case TermsError() when error != null:
return error(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements TermsState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TermsState.initial()';
}


}




/// @nodoc


class TermsLoading implements TermsState {
  const TermsLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TermsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TermsState.loading()';
}


}




/// @nodoc


class TermsLoaded implements TermsState {
  const TermsLoaded(this.acceptance);
  

 final  TermsAcceptanceModel acceptance;

/// Create a copy of TermsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TermsLoadedCopyWith<TermsLoaded> get copyWith => _$TermsLoadedCopyWithImpl<TermsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TermsLoaded&&(identical(other.acceptance, acceptance) || other.acceptance == acceptance));
}


@override
int get hashCode => Object.hash(runtimeType,acceptance);

@override
String toString() {
  return 'TermsState.loaded(acceptance: $acceptance)';
}


}

/// @nodoc
abstract mixin class $TermsLoadedCopyWith<$Res> implements $TermsStateCopyWith<$Res> {
  factory $TermsLoadedCopyWith(TermsLoaded value, $Res Function(TermsLoaded) _then) = _$TermsLoadedCopyWithImpl;
@useResult
$Res call({
 TermsAcceptanceModel acceptance
});




}
/// @nodoc
class _$TermsLoadedCopyWithImpl<$Res>
    implements $TermsLoadedCopyWith<$Res> {
  _$TermsLoadedCopyWithImpl(this._self, this._then);

  final TermsLoaded _self;
  final $Res Function(TermsLoaded) _then;

/// Create a copy of TermsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? acceptance = null,}) {
  return _then(TermsLoaded(
null == acceptance ? _self.acceptance : acceptance // ignore: cast_nullable_to_non_nullable
as TermsAcceptanceModel,
  ));
}


}

/// @nodoc


class TermsSaving implements TermsState {
  const TermsSaving();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TermsSaving);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TermsState.saving()';
}


}




/// @nodoc


class TermsSaved implements TermsState {
  const TermsSaved();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TermsSaved);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TermsState.saved()';
}


}




/// @nodoc


class TermsError implements TermsState {
  const TermsError({required this.error});
  

 final  String error;

/// Create a copy of TermsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TermsErrorCopyWith<TermsError> get copyWith => _$TermsErrorCopyWithImpl<TermsError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TermsError&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'TermsState.error(error: $error)';
}


}

/// @nodoc
abstract mixin class $TermsErrorCopyWith<$Res> implements $TermsStateCopyWith<$Res> {
  factory $TermsErrorCopyWith(TermsError value, $Res Function(TermsError) _then) = _$TermsErrorCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class _$TermsErrorCopyWithImpl<$Res>
    implements $TermsErrorCopyWith<$Res> {
  _$TermsErrorCopyWithImpl(this._self, this._then);

  final TermsError _self;
  final $Res Function(TermsError) _then;

/// Create a copy of TermsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(TermsError(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
