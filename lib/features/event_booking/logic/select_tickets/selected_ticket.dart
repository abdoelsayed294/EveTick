import 'package:evetick/features/event_booking/data/models/ticket_tier_model.dart';

class SelectedTicket {
  const SelectedTicket({
    required this.tierIndex,
    required this.tier,
    required this.quantity,
  });

  final int tierIndex;
  final TicketTier tier;
  final int quantity;

  double get subtotal => tier.price * quantity;
}
