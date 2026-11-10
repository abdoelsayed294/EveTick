import 'package:evetick/features/event_booking/data/models/ticket_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ticket_state.freezed.dart';

@freezed
class TicketState with _$TicketState {
  const factory TicketState.initial() = _Initial;
  const factory TicketState.loading() = Loading;
  const factory TicketState.success(TicketModel ticket) = Success;
  const factory TicketState.error({required String error}) = Error;
}
