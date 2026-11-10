import 'package:evetick/features/event_booking/logic/payment/payment_cubit.dart';
import 'package:evetick/features/event_booking/logic/payment/payment_state.dart';
import 'package:evetick/features/event_booking/ui/widgets/checkout_widgets/checkout_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutBottomBarBlocBuilder extends StatelessWidget {
  const CheckoutBottomBarBlocBuilder({super.key, required this.onPay});

  final VoidCallback onPay;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentCubit, PaymentState>(
      builder: (context, state) {
        final isLoading = state.maybeWhen(
          loading: () => true,
          awaitingPayment: (_, __) => true,
          orElse: () => false,
        );

        return CheckoutBottomBar(onPay: onPay, isLoading: isLoading);
      },
    );
  }
}
