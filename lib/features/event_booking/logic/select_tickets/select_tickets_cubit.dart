
import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/event_booking/data/repo/event_booking_repo.dart';
import 'package:evetick/features/event_booking/logic/select_tickets/select_tickets_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class SelectTicketsCubit extends Cubit<SelectTicketsState> {
  final EventBookingRepo eventBookingRepo;
  SelectTicketsCubit(this.eventBookingRepo) : super(SelectTicketsState.initial());

  Future<void> getTicketTier(String eventId) async {
    emit(SelectTicketsState.loading());
    final result = await eventBookingRepo.getTicketTier(eventId);
    result.when(
      success: (ticketTiers) {
        emit(SelectTicketsState.success(ticketTiers));
      },
      failure: (error) {
        emit(SelectTicketsState.error(error: error.message));
      },
    );
  }

  
}
