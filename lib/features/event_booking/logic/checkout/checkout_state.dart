import 'package:evetick/features/event_booking/data/models/event_model.dart';
import 'package:evetick/features/event_booking/data/models/order_model.dart';
import 'package:evetick/features/event_booking/logic/select_chair/select_chair_state.dart';
import 'package:evetick/features/event_booking/logic/select_tickets/select_tickets_state.dart';

enum CheckoutStatus {
  loading, // loading the event
  ready,
  error, // event failed to load
  placing, // order is being created
  orderFailed, // order failed (screen stays visible)
  success,
}

class CheckoutState {
  const CheckoutState({
    this.status = CheckoutStatus.loading,
    this.errorMessage,
    this.event,
    this.tickets = const [],
    this.seats = const [],
    this.orderId,
  });

  final CheckoutStatus status;
  final String? errorMessage;
  final EventModel? event;
  final List<SelectedTicket> tickets;
  final List<SelectedSeat> seats;
  final String? orderId;

  double get subtotal => tickets.fold(0.0, (sum, t) => sum + t.subtotal);

  OrderPricing get pricing => OrderPricing(subtotal);

  CheckoutState copyWith({
    CheckoutStatus? status,
    String? errorMessage,
    EventModel? event,
    List<SelectedTicket>? tickets,
    List<SelectedSeat>? seats,
    String? orderId,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      event: event ?? this.event,
      tickets: tickets ?? this.tickets,
      seats: seats ?? this.seats,
      orderId: orderId ?? this.orderId,
    );
  }
}
