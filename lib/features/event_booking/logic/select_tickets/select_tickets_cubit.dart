import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/event_booking/data/models/ticket_tier_model.dart';
import 'package:evetick/features/event_booking/data/repo/event_booking_repo.dart';
import 'package:evetick/features/event_booking/logic/select_tickets/select_tickets_state.dart';
import 'package:evetick/features/event_booking/logic/select_tickets/selected_ticket.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectTicketsCubit extends Cubit<SelectTicketsState> {
  final EventBookingRepo eventBookingRepo;

  SelectTicketsCubit(this.eventBookingRepo)
      : super(const SelectTicketsState.initial());

  static const int maxTicketsPerOrder = 10;

  Future<void> getTicketTier(String eventId) async {
    emit(const SelectTicketsState.loading());

    final result = await eventBookingRepo.getTicketTier(eventId);
    result.when(
      success: (ticketTiers) =>
          _emitSuccess(ticketTiers, List.filled(ticketTiers.length, 0)),
      failure: (failure) =>
          emit(SelectTicketsState.error(error: failure.message)),
    );
  }

  bool canIncrease(int index) {
    final current = state.mapOrNull(success: (s) => s);
    if (current == null) return false;
    if (current.totalQuantity >= maxTicketsPerOrder) return false;
    return current.quantities[index] < current.ticketTiers[index].quantity;
  }

  void increase(int index) {
    final current = state.mapOrNull(success: (s) => s);
    if (current == null || !canIncrease(index)) return;
    _setQuantity(current.ticketTiers, current.quantities, index,
        current.quantities[index] + 1);
  }

  void decrease(int index) {
    final current = state.mapOrNull(success: (s) => s);
    if (current == null || current.quantities[index] == 0) return;
    _setQuantity(current.ticketTiers, current.quantities, index,
        current.quantities[index] - 1);
  }

  void _setQuantity(
    List<TicketTier> tiers,
    List<int> quantities,
    int index,
    int value,
  ) {
    final updated = List<int>.of(quantities)..[index] = value;
    _emitSuccess(tiers, updated);
  }

  void _emitSuccess(List<TicketTier> tiers, List<int> quantities) {
    final selected = <SelectedTicket>[
      for (var i = 0; i < tiers.length; i++)
        if (quantities[i] > 0)
          SelectedTicket(
            tierIndex: i,
            tier: tiers[i],
            quantity: quantities[i],
          ),
    ];

    emit(
      SelectTicketsState.success(
        ticketTiers: tiers,
        quantities: quantities,
        selectedTickets: selected,
        totalQuantity: quantities.fold(0, (sum, q) => sum + q),
        totalPrice: selected.fold(0.0, (sum, t) => sum + t.subtotal),
      ),
    );
  }
}
