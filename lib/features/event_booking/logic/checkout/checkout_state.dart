import 'package:evetick/features/event_booking/data/models/event_model.dart';
import 'package:evetick/features/event_booking/data/models/order_model.dart';
import 'package:evetick/features/event_booking/logic/select_chair/select_chair_state.dart';
import 'package:evetick/features/event_booking/logic/select_tickets/select_tickets_state.dart';

enum CheckoutStatus {
  loading, // loading the event
  ready,
  error, // event failed to load
  placing, // asking the server to start the payment
  awaitingPayment, // Paymob page is open, waiting for the server to confirm
  paymentPending, // page closed, payment not confirmed (yet)
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
    this.ticketSections = const [],
    this.orderId,
    this.paymentUrl,
  });

  final CheckoutStatus status;
  final String? errorMessage;
  final EventModel? event;
  final List<SelectedTicket> tickets;
  final List<SelectedSeat> seats;

  /// Section of each entry in [tickets] (events without seat picking).
  final List<String?> ticketSections;
  final String? orderId;

  /// Paymob checkout page to open while [status] is awaitingPayment.
  final String? paymentUrl;

  double get subtotal => tickets.fold(0.0, (sum, t) => sum + t.subtotal);

  OrderPricing get pricing => OrderPricing(subtotal);

  /// "Seats: A1, A2" or "Sections: VIP Zone × 2" (empty if neither).
  String get accessSummary {
    if (seats.isNotEmpty) {
      return 'Seats: ${seats.map((s) => s.label).join(', ')}';
    }
    final lines = <String>[
      for (var i = 0; i < tickets.length; i++)
        if (i < ticketSections.length && ticketSections[i] != null)
          '${ticketSections[i]} × ${tickets[i].quantity}',
    ];
    return lines.isEmpty ? '' : 'Sections: ${lines.join(', ')}';
  }

  CheckoutState copyWith({
    CheckoutStatus? status,
    String? errorMessage,
    EventModel? event,
    List<SelectedTicket>? tickets,
    List<SelectedSeat>? seats,
    List<String?>? ticketSections,
    String? orderId,
    String? paymentUrl,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      event: event ?? this.event,
      tickets: tickets ?? this.tickets,
      seats: seats ?? this.seats,
      ticketSections: ticketSections ?? this.ticketSections,
      orderId: orderId ?? this.orderId,
      paymentUrl: paymentUrl ?? this.paymentUrl,
    );
  }
}
