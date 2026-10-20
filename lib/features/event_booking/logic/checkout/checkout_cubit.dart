import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/event_booking/data/models/event_model.dart';
import 'package:evetick/features/event_booking/data/models/order_pricing.dart';
import 'package:evetick/features/event_booking/data/repo/event_booking_repo.dart';
import 'package:evetick/features/event_booking/logic/checkout/checkout_state.dart';
import 'package:evetick/features/event_booking/logic/select_chair/selected_seat.dart';
import 'package:evetick/features/event_booking/logic/select_tickets/selected_ticket.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final EventBookingRepo eventBookingRepo;

  CheckoutCubit(this.eventBookingRepo) : super(const CheckoutState.initial());

  List<SelectedTicket> _tickets = const [];
  List<SelectedSeat> _seats = const [];
  List<String?> _ticketSections = const [];

  Future<void> getEvent(String eventId) async {
    emit(const CheckoutState.loading());

    final result = await eventBookingRepo.getEvent(eventId);
    result.when(
      success: (event) => _emitSuccess(event),
      failure: (failure) => emit(CheckoutState.error(error: failure.message)),
    );
  }

  void setSelection({
    required List<SelectedTicket> tickets,
    required List<SelectedSeat> seats,
    List<String?> ticketSections = const [],
  }) {
    _tickets = tickets;
    _seats = seats;
    _ticketSections = ticketSections;

    final current = state.mapOrNull(success: (s) => s);
    if (current != null) _emitSuccess(current.event);
  }

  void _emitSuccess(EventModel event) {
    final subtotal = _tickets.fold(0.0, (sum, t) => sum + t.subtotal);

    emit(
      CheckoutState.success(
        event: event,
        tickets: _tickets,
        seats: _seats,
        ticketSections: _ticketSections,
        ticketLabel: _tickets
            .map((t) => '${t.quantity}X ${t.tier.name.toUpperCase()}')
            .join(' • '),
        accessSummary: _accessSummary(),
        pricing: OrderPricing(subtotal),
      ),
    );
  }

  String _accessSummary() {
    if (_seats.isNotEmpty) {
      return 'Seats: ${_seats.map((s) => s.label).join(', ')}';
    }
    final lines = <String>[
      for (var i = 0; i < _tickets.length; i++)
        if (i < _ticketSections.length && _ticketSections[i] != null)
          '${_ticketSections[i]} × ${_tickets[i].quantity}',
    ];
    return lines.isEmpty ? '' : 'Sections: ${lines.join(', ')}';
  }
}
