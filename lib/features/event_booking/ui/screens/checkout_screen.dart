import 'package:evetick/core/helpers/app_regex.dart';
import 'package:evetick/core/helpers/date_formatter.dart';
import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/core/widgets/app_text_form_field.dart';
import 'package:evetick/features/event_booking/logic/checkout/checkout_cubit.dart';
import 'package:evetick/features/event_booking/logic/checkout/checkout_state.dart';
import 'package:evetick/features/event_booking/ui/widgets/checkout_widgets/booking_summary_card.dart';
import 'package:evetick/features/event_booking/ui/widgets/checkout_widgets/checkout_bottom_bar.dart';
import 'package:evetick/features/event_booking/ui/widgets/checkout_widgets/order_summary_card.dart';
import 'package:evetick/features/event_booking/ui/widgets/checkout_widgets/payment_method_tile.dart';
import 'package:evetick/core/widgets/app_error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum PaymentMethod { creditCard, applePay, payPal }

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key, this.onOrderPlaced});

  /// Called once the order was saved successfully.
  final VoidCallback? onOrderPlaced;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  PaymentMethod _selectedMethod = PaymentMethod.creditCard;

  final _cardHolderController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void dispose() {
    _cardHolderController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _onPay() {
    if (_selectedMethod == PaymentMethod.creditCard &&
        !(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    // Only the method name is saved, never the card details.
    context.read<CheckoutCubit>().placeOrder(_selectedMethod.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CheckoutCubit, CheckoutState>(
        listener: (context, state) {
          if (state.status == CheckoutStatus.success) {
            widget.onOrderPlaced?.call();
          } else if (state.status == CheckoutStatus.orderFailed) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? 'Something went wrong')),
              );
          }
        },
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

          return Form(
            key: _formKey,
            child: Column(
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
                        PaymentMethodTile(
                          icon: Icons.credit_card_rounded,
                          label: 'Credit Card',
                          isSelected: _selectedMethod == PaymentMethod.creditCard,
                          onTap: () => setState(() => _selectedMethod = PaymentMethod.creditCard),
                        ),
                        verticalSpace(8),
                        PaymentMethodTile(
                          icon: Icons.apple,
                          label: 'Apple Pay',
                          isSelected: _selectedMethod == PaymentMethod.applePay,
                          onTap: () => setState(() => _selectedMethod = PaymentMethod.applePay),
                        ),
                        verticalSpace(8),
                        PaymentMethodTile(
                          icon: Icons.account_balance_wallet_rounded,
                          label: 'PayPal',
                          isSelected: _selectedMethod == PaymentMethod.payPal,
                          onTap: () => setState(() => _selectedMethod = PaymentMethod.payPal),
                        ),
                        if (_selectedMethod == PaymentMethod.creditCard) ...[
                          verticalSpace(24),
                          AppTextFormField(
                            label: 'Cardholder Name',
                            hintText: 'Ahmed Mohamed',
                            controller: _cardHolderController,
                            backgroundColor: context.colors.lightBlue,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            validator: (value) => (value == null || value.trim().isEmpty)
                                ? 'Please enter the cardholder name'
                                : null,
                          ),
                          verticalSpace(16),
                          AppTextFormField(
                            label: 'Card Number',
                            hintText: '0000 0000 0000 0000',
                            controller: _cardNumberController,
                            backgroundColor: context.colors.lightBlue,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(16),
                            ],
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            validator: (value) => AppRegex.isCardNumberValid(value ?? '')
                                ? null
                                : 'Enter a valid 16-digit card number',
                          ),
                          verticalSpace(16),
                          Row(
                            children: [
                              Expanded(
                                child: AppTextFormField(
                                  label: 'Expiry Date',
                                  hintText: 'MM/YY',
                                  controller: _expiryDateController,
                                  backgroundColor: context.colors.lightBlue,
                                  keyboardType: TextInputType.datetime,
                                  inputFormatters: [LengthLimitingTextInputFormatter(5)],
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  validator: (value) => AppRegex.isExpiryDateValid(value ?? '')
                                      ? null
                                      : 'Invalid',
                                ),
                              ),
                              horizontalSpace(16),
                              Expanded(
                                child: AppTextFormField(
                                  label: 'CVV',
                                  hintText: '***',
                                  controller: _cvvController,
                                  backgroundColor: context.colors.lightBlue,
                                  isObscureText: true,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(4),
                                  ],
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  validator: (value) =>
                                      AppRegex.isCvvValid(value ?? '') ? null : 'Invalid',
                                ),
                              ),
                            ],
                          ),
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
                  isLoading: state.status == CheckoutStatus.placing,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
