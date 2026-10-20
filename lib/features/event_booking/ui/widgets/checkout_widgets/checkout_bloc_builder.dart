import 'package:evetick/core/helpers/date_formatter.dart';
import 'package:evetick/core/widgets/app_error_view.dart';
import 'package:evetick/features/event_booking/logic/checkout/checkout_cubit.dart';
import 'package:evetick/features/event_booking/logic/checkout/checkout_state.dart';
import 'package:evetick/features/event_booking/logic/payment/payment_cubit.dart';
import 'package:evetick/features/event_booking/ui/widgets/checkout_widgets/checkout_content.dart';
import 'package:evetick/features/event_booking/ui/widgets/checkout_widgets/payment_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutBlocBuilder extends StatelessWidget {
  const CheckoutBlocBuilder({
    super.key,
    required this.selectedMethod,
    required this.onMethodSelected,
  });

  final PaymentMethod selectedMethod;
  final ValueChanged<PaymentMethod> onMethodSelected;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutCubit, CheckoutState>(
      builder: (context, state) {
        return state.maybeMap(
          success: (s) => CheckoutContent(
            ticketLabel: s.ticketLabel,
            eventName: s.event.title,
            date: formatEventDate(s.event.startAt),
            time: formatEventTime(s.event.startAt),
            imageUrl: s.event.coverImageUrl,
            accessSummary: s.accessSummary,
            subtotal: s.pricing.subtotal,
            serviceFee: s.pricing.serviceFee,
            taxes: s.pricing.taxes,
            selectedMethod: selectedMethod,
            onMethodSelected: onMethodSelected,
            onPay: () => context.read<PaymentCubit>().placeOrder(
                  event: s.event,
                  tickets: s.tickets,
                  seats: s.seats,
                  paymentMethod: selectedMethod.apiValue,
                ),
          ),
          error: (e) => AppErrorView(message: e.error),
          orElse: () => const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
