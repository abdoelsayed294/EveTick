import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/event_booking/data/repo/event_booking_repo.dart';
import 'package:evetick/features/event_booking/logic/ticket/ticket_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TicketCubit extends Cubit<TicketState> {
  final EventBookingRepo eventBookingRepo;

  TicketCubit(this.eventBookingRepo) : super(const TicketState());

  Future<void> getOrder(String orderId) async {
    emit(const TicketState());

    final result = await eventBookingRepo.getOrder(orderId);
    result.when(
      success: (ticket) =>
          emit(TicketState(status: TicketStatus.success, ticket: ticket)),
      failure: (error) => emit(
        TicketState(status: TicketStatus.error, errorMessage: error.message),
      ),
    );
  }
}
