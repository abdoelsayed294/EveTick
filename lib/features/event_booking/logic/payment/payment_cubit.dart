import 'dart:async';

import 'package:evetick/core/config/paymob_config.dart';
import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/event_booking/data/models/event_model.dart';
import 'package:evetick/features/event_booking/data/models/order_model.dart';
import 'package:evetick/features/event_booking/data/models/order_seat.dart';
import 'package:evetick/features/event_booking/data/models/order_ticket_item.dart';
import 'package:evetick/features/event_booking/data/repo/event_booking_repo.dart';
import 'package:evetick/features/event_booking/logic/payment/payment_state.dart';
import 'package:evetick/features/event_booking/logic/select_chair/selected_seat.dart';
import 'package:evetick/features/event_booking/logic/select_tickets/selected_ticket.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final EventBookingRepo eventBookingRepo;

  PaymentCubit(this.eventBookingRepo) : super(const PaymentState.initial());

  StreamSubscription<String>? _orderSub;

  Future<void> placeOrder({
    required EventModel event,
    required List<SelectedTicket> tickets,
    required List<SelectedSeat> seats,
    required String paymentMethod,
  }) async {
    final isBusy = state.maybeWhen(
      loading: () => true,
      awaitingPayment: (_, __) => true,
      orElse: () => false,
    );
    if (isBusy) return;

    final pending = state.mapOrNull(paymentPending: (p) => p);
    if (pending != null && pending.paymentUrl.isNotEmpty) {
      emit(
        PaymentState.awaitingPayment(
          orderId: pending.orderId,
          paymentUrl: pending.paymentUrl,
        ),
      );
      return;
    }

    emit(const PaymentState.loading());

    final order = OrderModel(
      eventId: event.id,
      eventTitle: event.title,
      eventCoverImageUrl: event.coverImageUrl,
      eventStartAt: event.startAt,
      eventEndAt: event.endAt,
      eventCategory: event.category,
      eventLocation: event.location,
      tickets: tickets
          .map((t) => OrderTicketItem(
                tierIndex: t.tierIndex,
                name: t.tier.name,
                price: t.tier.price,
                quantity: t.quantity,
              ))
          .toList(),
      seats: seats
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
        emit(
          PaymentState.awaitingPayment(
            orderId: session.orderId,
            paymentUrl: PaymobConfig.checkoutUrl(session.clientSecret),
          ),
        );
      },
      failure: (failure) => emit(PaymentState.error(error: failure.message)),
    );
  }

  void onPaymentClosed() {
    final awaiting = state.mapOrNull(awaitingPayment: (a) => a);
    if (awaiting == null) return;

    emit(
      PaymentState.paymentPending(
        orderId: awaiting.orderId,
        paymentUrl: awaiting.paymentUrl,
      ),
    );
  }

  void _watchOrder(String orderId) {
    _orderSub?.cancel();
    _orderSub = eventBookingRepo.watchOrderStatus(orderId).listen((status) {
      switch (status) {
        case 'confirmed':
          _orderSub?.cancel();
          emit(PaymentState.success(orderId: orderId));
          break;
        case 'failed':
        case 'expired':
        case 'amount_mismatch':
          _orderSub?.cancel();
          emit(
            PaymentState.error(
              error: status == 'expired'
                  ? 'The payment time ran out. Please try again.'
                  : 'The payment could not be completed. Please try again.',
            ),
          );
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
