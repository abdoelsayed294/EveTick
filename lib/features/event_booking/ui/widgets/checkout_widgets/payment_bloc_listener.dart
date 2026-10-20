import 'package:evetick/core/services/toast/app_toast.dart';
import 'package:evetick/features/event_booking/logic/payment/payment_cubit.dart';
import 'package:evetick/features/event_booking/logic/payment/payment_state.dart';
import 'package:evetick/features/event_booking/ui/screens/payment_webview_screen.dart';
import 'package:evetick/features/event_booking/ui/widgets/checkout_widgets/payment_method.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentBlocListener extends StatefulWidget {
  const PaymentBlocListener({
    super.key,
    required this.selectedMethod,
    required this.onOrderPlaced,
    required this.child,
  });

  final PaymentMethod selectedMethod;

  final ValueChanged<String> onOrderPlaced;
  final Widget child;

  @override
  State<PaymentBlocListener> createState() => _PaymentBlocListenerState();
}

class _PaymentBlocListenerState extends State<PaymentBlocListener> {
  bool _paymentPageOpen = false;

  void _openPaymentPage(String url) {
    if (_paymentPageOpen || url.isEmpty) return;
    _paymentPageOpen = true;
    final cubit = context.read<PaymentCubit>();
    Navigator.of(context)
        .push<void>(
          MaterialPageRoute(builder: (_) => PaymentWebViewScreen(url: url)),
        )
        .then((_) {
      _paymentPageOpen = false;
      cubit.onPaymentClosed();
    });
  }

  void _closePaymentPage(BuildContext context) {
    if (_paymentPageOpen) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentCubit, PaymentState>(
      listener: (context, state) {
        state.whenOrNull(
          awaitingPayment: (orderId, paymentUrl) =>
              _openPaymentPage(paymentUrl),
          paymentPending: (orderId, paymentUrl) {
            AppToast.error(
              widget.selectedMethod == PaymentMethod.kiosk
                  ? 'Pay at the kiosk with your reference code. Your ticket '
                      'is issued automatically once the payment is received.'
                  : 'We have not received your payment yet. If you already '
                      'paid, your ticket will appear shortly.',
            );
          },
          success: (orderId) {
            _closePaymentPage(context);
            widget.onOrderPlaced(orderId);
          },
          error: (error) {
            _closePaymentPage(context);
            AppToast.error(
              error.isEmpty
                  ? AppLocalizations.of(context)!.toastGenericError
                  : error,
            );
          },
        );
      },
      child: widget.child,
    );
  }
}
