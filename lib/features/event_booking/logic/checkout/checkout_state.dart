import 'package:evetick/features/event_booking/data/models/event_model.dart';
import 'package:evetick/features/event_booking/data/models/order_pricing.dart';
import 'package:evetick/features/event_booking/logic/select_chair/selected_seat.dart';
import 'package:evetick/features/event_booking/logic/select_tickets/selected_ticket.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'checkout_state.freezed.dart';

@freezed
class CheckoutState with _$CheckoutState {
  const factory CheckoutState.initial() = _Initial;
  const factory CheckoutState.loading() = Loading;
  const factory CheckoutState.success({
    required EventModel event,
    required List<SelectedTicket> tickets,
    required List<SelectedSeat> seats,

    required List<String?> ticketSections,

    required String ticketLabel,

    required String accessSummary,
    required OrderPricing pricing,
  }) = Success;
  const factory CheckoutState.error({required String error}) = Error;
}
