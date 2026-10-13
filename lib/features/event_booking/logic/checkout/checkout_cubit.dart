import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/event_booking/data/models/order_model.dart';
import 'package:evetick/features/event_booking/data/repo/event_booking_repo.dart';
import 'package:evetick/features/event_booking/logic/checkout/checkout_state.dart';
import 'package:evetick/features/event_booking/logic/select_chair/select_chair_state.dart';
import 'package:evetick/features/event_booking/logic/select_tickets/select_tickets_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final EventBookingRepo eventBookingRepo;

  CheckoutCubit(this.eventBookingRepo) : super(const CheckoutState());

  Future<void> getEvent(String eventId) async {
    emit(const CheckoutState());

    final result = await eventBookingRepo.getEvent(eventId);
    result.when(
      success: (event) =>
          emit(state.copyWith(status: CheckoutStatus.ready, event: event)),
      failure: (error) => emit(
        state.copyWith(
          status: CheckoutStatus.error,
          errorMessage: error.message,
        ),
      ),
    );
  }

  /// Called when the user leaves the seats step.
  void setSelection({
    required List<SelectedTicket> tickets,
    required List<SelectedSeat> seats,
    List<String?> ticketSections = const [],
  }) {
    emit(
      state.copyWith(
        tickets: tickets,
        seats: seats,
        ticketSections: ticketSections,
      ),
    );
  }

  Future<void> placeOrder(String paymentMethod) async {
    final event = state.event;
    if (event == null || state.status == CheckoutStatus.placing) return;

    emit(state.copyWith(status: CheckoutStatus.placing));

    final order = OrderModel(
      eventId: event.id,
      eventTitle: event.title,
      eventCoverImageUrl: event.coverImageUrl,
      eventStartAt: event.startAt,
      eventEndAt: event.endAt,
      eventCategory: event.category,
      eventLocation: event.location,
      tickets: state.tickets
          .map((t) => OrderTicketItem(
                tierIndex: t.tierIndex,
                name: t.tier.name,
                price: t.tier.price,
                quantity: t.quantity,
              ))
          .toList(),
      seats: state.seats
          .map((s) => OrderSeat(
                rowIndex: s.rowIndex,
                seatIndex: s.seatIndex,
                label: s.label,
              ))
          .toList(),
      paymentMethod: paymentMethod,
    );

    final result = await eventBookingRepo.placeOrder(order);
    result.when(
      success: (orderId) => emit(
        state.copyWith(status: CheckoutStatus.success, orderId: orderId),
      ),
      failure: (error) => emit(
        state.copyWith(
          status: CheckoutStatus.orderFailed,
          errorMessage: error.message,
        ),
      ),
    );
  }
}
