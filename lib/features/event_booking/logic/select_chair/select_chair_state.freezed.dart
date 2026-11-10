// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'select_chair_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SelectChairState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SelectChairState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SelectChairState()';
}


}

/// @nodoc
class $SelectChairStateCopyWith<$Res>  {
$SelectChairStateCopyWith(SelectChairState _, $Res Function(SelectChairState) __);
}


/// Adds pattern-matching-related methods to [SelectChairState].
extension SelectChairStatePatterns on SelectChairState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( Loading value)?  loading,TResult Function( Success value)?  success,TResult Function( Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case Loading() when loading != null:
return loading(_that);case Success() when success != null:
return success(_that);case Error() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( Loading value)  loading,required TResult Function( Success value)  success,required TResult Function( Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case Loading():
return loading(_that);case Success():
return success(_that);case Error():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( Loading value)?  loading,TResult? Function( Success value)?  success,TResult? Function( Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case Loading() when loading != null:
return loading(_that);case Success() when success != null:
return success(_that);case Error() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( bool isSeated,  List<String> sectionNames,  List<String> rowLabels,  List<List<SeatStatus>> leftSeats,  List<List<SeatStatus>> rightSeats,  int maxSeats,  double totalPrice,  List<SelectedSeat> selectedSeats,  bool isSelectionComplete)?  success,TResult Function( String error)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case Loading() when loading != null:
return loading();case Success() when success != null:
return success(_that.isSeated,_that.sectionNames,_that.rowLabels,_that.leftSeats,_that.rightSeats,_that.maxSeats,_that.totalPrice,_that.selectedSeats,_that.isSelectionComplete);case Error() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( bool isSeated,  List<String> sectionNames,  List<String> rowLabels,  List<List<SeatStatus>> leftSeats,  List<List<SeatStatus>> rightSeats,  int maxSeats,  double totalPrice,  List<SelectedSeat> selectedSeats,  bool isSelectionComplete)  success,required TResult Function( String error)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case Loading():
return loading();case Success():
return success(_that.isSeated,_that.sectionNames,_that.rowLabels,_that.leftSeats,_that.rightSeats,_that.maxSeats,_that.totalPrice,_that.selectedSeats,_that.isSelectionComplete);case Error():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( bool isSeated,  List<String> sectionNames,  List<String> rowLabels,  List<List<SeatStatus>> leftSeats,  List<List<SeatStatus>> rightSeats,  int maxSeats,  double totalPrice,  List<SelectedSeat> selectedSeats,  bool isSelectionComplete)?  success,TResult? Function( String error)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case Loading() when loading != null:
return loading();case Success() when success != null:
return success(_that.isSeated,_that.sectionNames,_that.rowLabels,_that.leftSeats,_that.rightSeats,_that.maxSeats,_that.totalPrice,_that.selectedSeats,_that.isSelectionComplete);case Error() when error != null:
return error(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _Initial extends SelectChairState {
  const _Initial(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SelectChairState.initial()';
}


}




/// @nodoc


class Loading extends SelectChairState {
  const Loading(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SelectChairState.loading()';
}


}




/// @nodoc


class Success extends SelectChairState {
  const Success({required this.isSeated, required final  List<String> sectionNames, required final  List<String> rowLabels, required final  List<List<SeatStatus>> leftSeats, required final  List<List<SeatStatus>> rightSeats, required this.maxSeats, required this.totalPrice, required final  List<SelectedSeat> selectedSeats, required this.isSelectionComplete}): _sectionNames = sectionNames,_rowLabels = rowLabels,_leftSeats = leftSeats,_rightSeats = rightSeats,_selectedSeats = selectedSeats,super._();
  

/// true = the user picks seats, false = sections / tickets only.
 final  bool isSeated;
 final  List<String> _sectionNames;
 List<String> get sectionNames {
  if (_sectionNames is EqualUnmodifiableListView) return _sectionNames;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sectionNames);
}

 final  List<String> _rowLabels;
 List<String> get rowLabels {
  if (_rowLabels is EqualUnmodifiableListView) return _rowLabels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rowLabels);
}

 final  List<List<SeatStatus>> _leftSeats;
 List<List<SeatStatus>> get leftSeats {
  if (_leftSeats is EqualUnmodifiableListView) return _leftSeats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_leftSeats);
}

 final  List<List<SeatStatus>> _rightSeats;
 List<List<SeatStatus>> get rightSeats {
  if (_rightSeats is EqualUnmodifiableListView) return _rightSeats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rightSeats);
}

/// Number of tickets bought in the previous step = seats to pick.
 final  int maxSeats;
/// Price of the tickets chosen in the previous step.
 final  double totalPrice;
 final  List<SelectedSeat> _selectedSeats;
 List<SelectedSeat> get selectedSeats {
  if (_selectedSeats is EqualUnmodifiableListView) return _selectedSeats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_selectedSeats);
}

 final  bool isSelectionComplete;

/// Create a copy of SelectChairState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SuccessCopyWith<Success> get copyWith => _$SuccessCopyWithImpl<Success>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Success&&(identical(other.isSeated, isSeated) || other.isSeated == isSeated)&&const DeepCollectionEquality().equals(other._sectionNames, _sectionNames)&&const DeepCollectionEquality().equals(other._rowLabels, _rowLabels)&&const DeepCollectionEquality().equals(other._leftSeats, _leftSeats)&&const DeepCollectionEquality().equals(other._rightSeats, _rightSeats)&&(identical(other.maxSeats, maxSeats) || other.maxSeats == maxSeats)&&(identical(other.totalPrice, totalPrice) || other.totalPrice == totalPrice)&&const DeepCollectionEquality().equals(other._selectedSeats, _selectedSeats)&&(identical(other.isSelectionComplete, isSelectionComplete) || other.isSelectionComplete == isSelectionComplete));
}


@override
int get hashCode => Object.hash(runtimeType,isSeated,const DeepCollectionEquality().hash(_sectionNames),const DeepCollectionEquality().hash(_rowLabels),const DeepCollectionEquality().hash(_leftSeats),const DeepCollectionEquality().hash(_rightSeats),maxSeats,totalPrice,const DeepCollectionEquality().hash(_selectedSeats),isSelectionComplete);

@override
String toString() {
  return 'SelectChairState.success(isSeated: $isSeated, sectionNames: $sectionNames, rowLabels: $rowLabels, leftSeats: $leftSeats, rightSeats: $rightSeats, maxSeats: $maxSeats, totalPrice: $totalPrice, selectedSeats: $selectedSeats, isSelectionComplete: $isSelectionComplete)';
}


}

/// @nodoc
abstract mixin class $SuccessCopyWith<$Res> implements $SelectChairStateCopyWith<$Res> {
  factory $SuccessCopyWith(Success value, $Res Function(Success) _then) = _$SuccessCopyWithImpl;
@useResult
$Res call({
 bool isSeated, List<String> sectionNames, List<String> rowLabels, List<List<SeatStatus>> leftSeats, List<List<SeatStatus>> rightSeats, int maxSeats, double totalPrice, List<SelectedSeat> selectedSeats, bool isSelectionComplete
});




}
/// @nodoc
class _$SuccessCopyWithImpl<$Res>
    implements $SuccessCopyWith<$Res> {
  _$SuccessCopyWithImpl(this._self, this._then);

  final Success _self;
  final $Res Function(Success) _then;

/// Create a copy of SelectChairState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? isSeated = null,Object? sectionNames = null,Object? rowLabels = null,Object? leftSeats = null,Object? rightSeats = null,Object? maxSeats = null,Object? totalPrice = null,Object? selectedSeats = null,Object? isSelectionComplete = null,}) {
  return _then(Success(
isSeated: null == isSeated ? _self.isSeated : isSeated // ignore: cast_nullable_to_non_nullable
as bool,sectionNames: null == sectionNames ? _self._sectionNames : sectionNames // ignore: cast_nullable_to_non_nullable
as List<String>,rowLabels: null == rowLabels ? _self._rowLabels : rowLabels // ignore: cast_nullable_to_non_nullable
as List<String>,leftSeats: null == leftSeats ? _self._leftSeats : leftSeats // ignore: cast_nullable_to_non_nullable
as List<List<SeatStatus>>,rightSeats: null == rightSeats ? _self._rightSeats : rightSeats // ignore: cast_nullable_to_non_nullable
as List<List<SeatStatus>>,maxSeats: null == maxSeats ? _self.maxSeats : maxSeats // ignore: cast_nullable_to_non_nullable
as int,totalPrice: null == totalPrice ? _self.totalPrice : totalPrice // ignore: cast_nullable_to_non_nullable
as double,selectedSeats: null == selectedSeats ? _self._selectedSeats : selectedSeats // ignore: cast_nullable_to_non_nullable
as List<SelectedSeat>,isSelectionComplete: null == isSelectionComplete ? _self.isSelectionComplete : isSelectionComplete // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class Error extends SelectChairState {
  const Error({required this.error}): super._();
  

 final  String error;

/// Create a copy of SelectChairState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ErrorCopyWith<Error> get copyWith => _$ErrorCopyWithImpl<Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Error&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'SelectChairState.error(error: $error)';
}


}

/// @nodoc
abstract mixin class $ErrorCopyWith<$Res> implements $SelectChairStateCopyWith<$Res> {
  factory $ErrorCopyWith(Error value, $Res Function(Error) _then) = _$ErrorCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class _$ErrorCopyWithImpl<$Res>
    implements $ErrorCopyWith<$Res> {
  _$ErrorCopyWithImpl(this._self, this._then);

  final Error _self;
  final $Res Function(Error) _then;

/// Create a copy of SelectChairState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(Error(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
