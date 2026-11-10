import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/features/event_booking/ui/widgets/checkout_widgets/booking_summary_card.dart';
import 'package:evetick/features/event_booking/ui/widgets/checkout_widgets/checkout_bottom_bar_bloc_builder.dart';
import 'package:evetick/features/event_booking/ui/widgets/checkout_widgets/order_summary_card.dart';
import 'package:evetick/features/event_booking/ui/widgets/checkout_widgets/payment_method.dart';
import 'package:evetick/features/event_booking/ui/widgets/checkout_widgets/payment_method_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckoutContent extends StatelessWidget {
  const CheckoutContent({
    super.key,
    required this.ticketLabel,
    required this.eventName,
    required this.date,
    required this.time,
    required this.imageUrl,
    required this.accessSummary,
    required this.subtotal,
    required this.serviceFee,
    required this.taxes,
    required this.selectedMethod,
    required this.onMethodSelected,
    required this.onPay,
  });

  final String ticketLabel;
  final String eventName;
  final String date;
  final String time;
  final String imageUrl;
  final String accessSummary;
  final double subtotal;
  final double serviceFee;
  final double taxes;
  final PaymentMethod selectedMethod;
  final ValueChanged<PaymentMethod> onMethodSelected;
  final VoidCallback onPay;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Booking Summary',
                    style: TextStyles.font16WhiteBold(context)),
                verticalSpace(16),
                BookingSummaryCard(
                  ticketLabel: ticketLabel,
                  eventName: eventName,
                  date: date,
                  time: time,
                  imageUrl: imageUrl,
                ),
                if (accessSummary.isNotEmpty) ...[
                  verticalSpace(8),
                  Text(
                    accessSummary,
                    style: TextStyles.font12LightGrayRegular(context),
                  ),
                ],
                verticalSpace(24),
                Text('Payment Method',
                    style: TextStyles.font16WhiteBold(context)),
                verticalSpace(16),
                for (final method in PaymentMethod.values) ...[
                  PaymentMethodTile(
                    icon: method.icon,
                    label: method.label,
                    isSelected: selectedMethod == method,
                    onTap: () => onMethodSelected(method),
                  ),
                  verticalSpace(8),
                ],
                verticalSpace(24),
                OrderSummaryCard(
                  subtotal: subtotal,
                  serviceFee: serviceFee,
                  taxes: taxes,
                ),
              ],
            ),
          ),
        ),
        CheckoutBottomBarBlocBuilder(onPay: onPay),
      ],
    );
  }
}
