import 'dart:async';

import 'package:evetick/core/services/result.dart';
import 'package:evetick/core/config/paymob_config.dart';
import 'package:evetick/features/event_booking/data/models/order_model.dart';
import 'package:evetick/features/event_booking/data/repo/event_booking_repo.dart';
import 'package:evetick/features/event_booking/logic/checkout/checkout_state.dart';
import 'package:evetick/features/event_booking/logic/select_chair/select_chair_state.dart';
import 'package:evetick/features/event_booking/logic/select_tickets/select_tickets_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final EventBookingRepo eventBookingRepo;

  CheckoutCubit(this.eventBookingRepo) : super(const CheckoutState());

  StreamSubscription<String>? _orderSub;

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

  /// [paymentMethod] must be 'CARD', 'WALLET' or 'KIOSK'.
  ///
  /// 1. The server reserves seats / stock and opens a Paymob payment.
  /// 2. The screen opens the Paymob page (status: awaitingPayment).
  /// 3. Paymob tells the server, the server sets the order to "confirmed",
  ///    and we see it here through [_watchOrder] (status: success).
  /// The app never decides by itself that a payment succeeded.
  Future<void> placeOrder(String paymentMethod) async {
    final event = state.event;
    if (event == null ||
        state.status == CheckoutStatus.placing ||
        state.status == CheckoutStatus.awaitingPayment) {
      return;
    }

    // Retrying while the previous attempt is still open: reuse its page.
    final existingUrl = state.paymentUrl;
    if (state.status == CheckoutStatus.paymentPending &&
        existingUrl != null &&
        existingUrl.isNotEmpty &&
        state.orderId != null) {
      emit(state.copyWith(status: CheckoutStatus.awaitingPayment));
      return;
    }

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

    final result = await eventBookingRepo.createPayment(order);
    result.when(
      success: (session) {
        _watchOrder(session.orderId);
        emit(state.copyWith(
          status: CheckoutStatus.awaitingPayment,
          orderId: session.orderId,
          paymentUrl: PaymobConfig.checkoutUrl(session.clientSecret),
        ));
      },
      failure: (error) => emit(
        state.copyWith(
          status: CheckoutStatus.orderFailed,
          errorMessage: error.message,
        ),
      ),
    );
  }

  /// The user closed the Paymob page. If the order is not confirmed yet
  /// (kiosk payment, slow callback, or the user gave up) we keep listening.
  void onPaymentClosed() {
    if (state.status == CheckoutStatus.awaitingPayment) {
      emit(state.copyWith(status: CheckoutStatus.paymentPending));
    }
  }

  void _watchOrder(String orderId) {
    _orderSub?.cancel();
    _orderSub = eventBookingRepo.watchOrderStatus(orderId).listen((status) {
      switch (status) {
        case 'confirmed':
          _orderSub?.cancel();
          emit(state.copyWith(status: CheckoutStatus.success));
          break;
        case 'failed':
        case 'expired':
        case 'amount_mismatch':
          _orderSub?.cancel();
          emit(state.copyWith(
            status: CheckoutStatus.orderFailed,
            errorMessage: status == 'expired'
                ? 'The payment time ran out. Please try again.'
                : 'The payment could not be completed. Please try again.',
            paymentUrl: '',
          ));
          break;
      }
    });
  }

  @override
  Future<void> close() {
    _orderSub?.cancel();
    return super.close();
  }
}
