// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkout_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CheckoutState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckoutState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CheckoutState()';
}


}

/// @nodoc
class $CheckoutStateCopyWith<$Res>  {
$CheckoutStateCopyWith(CheckoutState _, $Res Function(CheckoutState) __);
}


/// Adds pattern-matching-related methods to [CheckoutState].
extension CheckoutStatePatterns on CheckoutState {
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( EventModel event,  List<SelectedTicket> tickets,  List<SelectedSeat> seats,  List<String?> ticketSections,  String ticketLabel,  String accessSummary,  OrderPricing pricing)?  success,TResult Function( String error)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case Loading() when loading != null:
return loading();case Success() when success != null:
return success(_that.event,_that.tickets,_that.seats,_that.ticketSections,_that.ticketLabel,_that.accessSummary,_that.pricing);case Error() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( EventModel event,  List<SelectedTicket> tickets,  List<SelectedSeat> seats,  List<String?> ticketSections,  String ticketLabel,  String accessSummary,  OrderPricing pricing)  success,required TResult Function( String error)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case Loading():
return loading();case Success():
return success(_that.event,_that.tickets,_that.seats,_that.ticketSections,_that.ticketLabel,_that.accessSummary,_that.pricing);case Error():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( EventModel event,  List<SelectedTicket> tickets,  List<SelectedSeat> seats,  List<String?> ticketSections,  String ticketLabel,  String accessSummary,  OrderPricing pricing)?  success,TResult? Function( String error)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case Loading() when loading != null:
return loading();case Success() when success != null:
return success(_that.event,_that.tickets,_that.seats,_that.ticketSections,_that.ticketLabel,_that.accessSummary,_that.pricing);case Error() when error != null:
return error(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements CheckoutState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CheckoutState.initial()';
}


}




/// @nodoc


class Loading implements CheckoutState {
  const Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CheckoutState.loading()';
}


}




/// @nodoc


class Success implements CheckoutState {
  const Success({required this.event, required final  List<SelectedTicket> tickets, required final  List<SelectedSeat> seats, required final  List<String?> ticketSections, required this.ticketLabel, required this.accessSummary, required this.pricing}): _tickets = tickets,_seats = seats,_ticketSections = ticketSections;
  

 final  EventModel event;
 final  List<SelectedTicket> _tickets;
 List<SelectedTicket> get tickets {
  if (_tickets is EqualUnmodifiableListView) return _tickets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tickets);
}

 final  List<SelectedSeat> _seats;
 List<SelectedSeat> get seats {
  if (_seats is EqualUnmodifiableListView) return _seats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_seats);
}

/// Section of each entry in [tickets] (events without seat picking).
 final  List<String?> _ticketSections;
/// Section of each entry in [tickets] (events without seat picking).
 List<String?> get ticketSections {
  if (_ticketSections is EqualUnmodifiableListView) return _ticketSections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ticketSections);
}

/// "2X VIP • 1X REGULAR"
 final  String ticketLabel;
/// "Seats: A1, A2" or "Sections: VIP Zone × 2" (empty if neither).
 final  String accessSummary;
 final  OrderPricing pricing;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SuccessCopyWith<Success> get copyWith => _$SuccessCopyWithImpl<Success>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Success&&(identical(other.event, event) || other.event == event)&&const DeepCollectionEquality().equals(other._tickets, _tickets)&&const DeepCollectionEquality().equals(other._seats, _seats)&&const DeepCollectionEquality().equals(other._ticketSections, _ticketSections)&&(identical(other.ticketLabel, ticketLabel) || other.ticketLabel == ticketLabel)&&(identical(other.accessSummary, accessSummary) || other.accessSummary == accessSummary)&&(identical(other.pricing, pricing) || other.pricing == pricing));
}


@override
int get hashCode => Object.hash(runtimeType,event,const DeepCollectionEquality().hash(_tickets),const DeepCollectionEquality().hash(_seats),const DeepCollectionEquality().hash(_ticketSections),ticketLabel,accessSummary,pricing);

@override
String toString() {
  return 'CheckoutState.success(event: $event, tickets: $tickets, seats: $seats, ticketSections: $ticketSections, ticketLabel: $ticketLabel, accessSummary: $accessSummary, pricing: $pricing)';
}


}

/// @nodoc
abstract mixin class $SuccessCopyWith<$Res> implements $CheckoutStateCopyWith<$Res> {
  factory $SuccessCopyWith(Success value, $Res Function(Success) _then) = _$SuccessCopyWithImpl;
@useResult
$Res call({
 EventModel event, List<SelectedTicket> tickets, List<SelectedSeat> seats, List<String?> ticketSections, String ticketLabel, String accessSummary, OrderPricing pricing
});




}
/// @nodoc
class _$SuccessCopyWithImpl<$Res>
    implements $SuccessCopyWith<$Res> {
  _$SuccessCopyWithImpl(this._self, this._then);

  final Success _self;
  final $Res Function(Success) _then;

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? event = null,Object? tickets = null,Object? seats = null,Object? ticketSections = null,Object? ticketLabel = null,Object? accessSummary = null,Object? pricing = null,}) {
  return _then(Success(
event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as EventModel,tickets: null == tickets ? _self._tickets : tickets // ignore: cast_nullable_to_non_nullable
as List<SelectedTicket>,seats: null == seats ? _self._seats : seats // ignore: cast_nullable_to_non_nullable
as List<SelectedSeat>,ticketSections: null == ticketSections ? _self._ticketSections : ticketSections // ignore: cast_nullable_to_non_nullable
as List<String?>,ticketLabel: null == ticketLabel ? _self.ticketLabel : ticketLabel // ignore: cast_nullable_to_non_nullable
as String,accessSummary: null == accessSummary ? _self.accessSummary : accessSummary // ignore: cast_nullable_to_non_nullable
as String,pricing: null == pricing ? _self.pricing : pricing // ignore: cast_nullable_to_non_nullable
as OrderPricing,
  ));
}


}

/// @nodoc


class Error implements CheckoutState {
  const Error({required this.error});
  

 final  String error;

/// Create a copy of CheckoutState
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
  return 'CheckoutState.error(error: $error)';
}


}

/// @nodoc
abstract mixin class $ErrorCopyWith<$Res> implements $CheckoutStateCopyWith<$Res> {
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

/// Create a copy of CheckoutState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(Error(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
