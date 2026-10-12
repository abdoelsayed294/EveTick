import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/event_booking/data/repo/event_booking_repo.dart';
import 'package:evetick/features/event_booking/logic/select_tickets/select_tickets_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectTicketsCubit extends Cubit<SelectTicketsState> {
  final EventBookingRepo eventBookingRepo;

  SelectTicketsCubit(this.eventBookingRepo) : super(const SelectTicketsState());

 
  static const int maxTicketsPerOrder = 10;

  Future<void> getTicketTier(String eventId) async {
    emit(const SelectTicketsState());

    final result = await eventBookingRepo.getTicketTier(eventId);
    result.when(
      success: (ticketTiers) => emit(
        SelectTicketsState(
          status: SelectTicketsStatus.success,
          ticketTiers: ticketTiers,
          quantities: List.filled(ticketTiers.length, 0),
        ),
      ),
      failure: (error) => emit(
        SelectTicketsState(
          status: SelectTicketsStatus.error,
          errorMessage: error.message,
        ),
      ),
    );
  }

  bool canIncrease(int index) {
    if (state.totalQuantity >= maxTicketsPerOrder) return false;
    return state.quantities[index] < state.ticketTiers[index].quantity;
  }

  void increase(int index) {
    if (!canIncrease(index)) return;
    _setQuantity(index, state.quantities[index] + 1);
  }

  void decrease(int index) {
    if (state.quantities[index] == 0) return;
    _setQuantity(index, state.quantities[index] - 1);
  }

  void _setQuantity(int index, int value) {
    final updated = List<int>.of(state.quantities)..[index] = value;
    emit(state.copyWith(quantities: updated));
  }
}
