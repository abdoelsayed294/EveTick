import 'package:evetick/features/event_booking/data/models/ticket_tier_model.dart';
import 'package:evetick/features/event_booking/logic/select_tickets/selected_ticket.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'select_tickets_state.freezed.dart';

@freezed
class SelectTicketsState with _$SelectTicketsState {
  const factory SelectTicketsState.initial() = _Initial;
  const factory SelectTicketsState.loading() = Loading;
  const factory SelectTicketsState.success({
    required List<TicketTier> ticketTiers,

    required List<int> quantities,

    required List<SelectedTicket> selectedTickets,
    required int totalQuantity,
    required double totalPrice,
  }) = Success;
  const factory SelectTicketsState.error({required String error}) = Error;
}
