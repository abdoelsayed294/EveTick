import 'package:evetick/features/event_booking/data/models/event_model.dart';

enum SelectTicketsStatus { loading, success, error }

/// A tier together with the quantity the user picked for it.
class SelectedTicket {
  const SelectedTicket({
    required this.tierIndex,
    required this.tier,
    required this.quantity,
  });

  /// Position of the tier inside the event's `ticketTiers` array.
  final int tierIndex;
  final TicketTier tier;
  final int quantity;

  double get subtotal => tier.price * quantity;
}

class SelectTicketsState {
  const SelectTicketsState({
    this.status = SelectTicketsStatus.loading,
    this.errorMessage,
    this.ticketTiers = const [],
    this.quantities = const [],
  });

  final SelectTicketsStatus status;
  final String? errorMessage;
  final List<TicketTier> ticketTiers;

  /// Same length / order as [ticketTiers].
  final List<int> quantities;

  int get totalQuantity => quantities.fold(0, (sum, q) => sum + q);

  double get totalPrice => selectedTickets.fold(0, (sum, t) => sum + t.subtotal);

  List<SelectedTicket> get selectedTickets => [
        for (var i = 0; i < ticketTiers.length; i++)
          if (quantities[i] > 0)
            SelectedTicket(
              tierIndex: i,
              tier: ticketTiers[i],
              quantity: quantities[i],
            ),
      ];

  SelectTicketsState copyWith({
    SelectTicketsStatus? status,
    String? errorMessage,
    List<TicketTier>? ticketTiers,
    List<int>? quantities,
  }) {
    return SelectTicketsState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      ticketTiers: ticketTiers ?? this.ticketTiers,
      quantities: quantities ?? this.quantities,
    );
  }
}
