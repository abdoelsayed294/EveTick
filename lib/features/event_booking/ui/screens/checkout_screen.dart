import 'package:evetick/features/event_booking/ui/widgets/checkout_widgets/checkout_bloc_builder.dart';
import 'package:evetick/features/event_booking/ui/widgets/checkout_widgets/payment_bloc_listener.dart';
import 'package:evetick/features/event_booking/ui/widgets/checkout_widgets/payment_method.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key, this.onOrderPlaced});

  final ValueChanged<String>? onOrderPlaced;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  PaymentMethod _selectedMethod = PaymentMethod.card;

  @override
  Widget build(BuildContext context) {
    return PaymentBlocListener(
      selectedMethod: _selectedMethod,
      onOrderPlaced: (orderId) => widget.onOrderPlaced?.call(orderId),
      child: Scaffold(
        body: CheckoutBlocBuilder(
          selectedMethod: _selectedMethod,
          onMethodSelected: (method) =>
              setState(() => _selectedMethod = method),
        ),
      ),
    );
  }
}
