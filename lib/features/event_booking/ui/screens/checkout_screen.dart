import 'package:evetick/core/helpers/date_formatter.dart';
import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/features/event_booking/logic/checkout/checkout_cubit.dart';
import 'package:evetick/features/event_booking/logic/checkout/checkout_state.dart';
import 'package:evetick/features/event_booking/ui/widgets/checkout_widgets/booking_summary_card.dart';
import 'package:evetick/features/event_booking/ui/widgets/checkout_widgets/checkout_bottom_bar.dart';
import 'package:evetick/features/event_booking/ui/widgets/checkout_widgets/order_summary_card.dart';
import 'package:evetick/features/event_booking/ui/screens/payment_webview_screen.dart';
import 'package:evetick/features/event_booking/ui/widgets/checkout_widgets/payment_method_tile.dart';
import 'package:evetick/core/widgets/app_error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Methods the server supports (value sent as `paymentMethod`).
enum PaymentMethod {
  card('CARD', Icons.credit_card_rounded, 'Credit / Debit Card'),
  wallet('WALLET', Icons.account_balance_wallet_rounded, 'Mobile Wallet'),
  kiosk('KIOSK', Icons.store_rounded, 'Cash at Kiosk (Aman / Masary)');

  const PaymentMethod(this.apiValue, this.icon, this.label);

  final String apiValue;
  final IconData icon;
  final String label;
}

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key, this.onOrderPlaced});

  /// Called once the server confirmed the payment.
  final VoidCallback? onOrderPlaced;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  PaymentMethod _selectedMethod = PaymentMethod.card;
  bool _paymentPageOpen = false;

  void _onPay() {
    context.read<CheckoutCubit>().placeOrder(_selectedMethod.apiValue);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// Opens the Paymob page. The cubit is told when the user closes it.
  void _openPaymentPage(String url) {
    if (_paymentPageOpen || url.isEmpty) return;
    _paymentPageOpen = true;
    final cubit = context.read<CheckoutCubit>();
    Navigator.of(context)
        .push<void>(
          MaterialPageRoute(builder: (_) => PaymentWebViewScreen(url: url)),
        )
        .then((_) {
      _paymentPageOpen = false;
      cubit.onPaymentClosed();
    });
  }

  void _onStateChanged(BuildContext context, CheckoutState state) {
    switch (state.status) {
      case CheckoutStatus.awaitingPayment:
        _openPaymentPage(state.paymentUrl ?? '');
        break;
      case CheckoutStatus.success:
        if (_paymentPageOpen) Navigator.of(context).pop(); // close Paymob page
        widget.onOrderPlaced?.call();
        break;
      case CheckoutStatus.paymentPending:
        _showMessage(
          _selectedMethod == PaymentMethod.kiosk
              ? 'Pay at the kiosk with your reference code. Your ticket '
                  'is issued automatically once the payment is received.'
              : 'We have not received your payment yet. If you already '
                  'paid, your ticket will appear shortly.',
        );
        break;
      case CheckoutStatus.orderFailed:
        if (_paymentPageOpen) Navigator.of(context).pop();
        _showMessage(state.errorMessage ?? 'Something went wrong');
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CheckoutCubit, CheckoutState>(
        listener: _onStateChanged,
        builder: (context, state) {
          final event = state.event;

          if (state.status == CheckoutStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == CheckoutStatus.error || event == null) {
            return AppErrorView(message: state.errorMessage);
          }

          final ticketLabel = state.tickets
              .map((t) => '${t.quantity}X ${t.tier.name.toUpperCase()}')
              .join(' • ');
          final accessSummary = state.accessSummary;
          final pricing = state.pricing;

          return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Booking Summary', style: TextStyles.font16WhiteBold(context)),
                        verticalSpace(16),
                        BookingSummaryCard(
                          ticketLabel: ticketLabel,
                          eventName: event.title,
                          date: formatEventDate(event.startAt),
                          time: formatEventTime(event.startAt),
                          imageUrl: event.coverImageUrl,
                        ),
                        if (accessSummary.isNotEmpty) ...[
                          verticalSpace(8),
                          Text(
                            accessSummary,
                            style: TextStyles.font12LightGrayRegular(context),
                          ),
                        ],
                        verticalSpace(24),
                        Text('Payment Method', style: TextStyles.font16WhiteBold(context)),
                        verticalSpace(16),
                        for (final method in PaymentMethod.values) ...[
                          PaymentMethodTile(
                            icon: method.icon,
                            label: method.label,
                            isSelected: _selectedMethod == method,
                            onTap: () => setState(() => _selectedMethod = method),
                          ),
                          verticalSpace(8),
                        ],
                        verticalSpace(24),
                        OrderSummaryCard(
                          subtotal: state.subtotal,
                          serviceFee: pricing.serviceFee,
                          taxes: pricing.taxes,
                        ),
                      ],
                    ),
                  ),
                ),
                CheckoutBottomBar(
                  onPay: _onPay,
                  isLoading: state.status == CheckoutStatus.placing ||
                      state.status == CheckoutStatus.awaitingPayment,
                ),
              ],
          );
        },
      ),
    );
  }
}
