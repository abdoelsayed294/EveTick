import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/features/event_booking/ui/widgets/checkout_widgets/price_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evetick/l10n/app_localizations.dart';

class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({
    super.key,
    required this.subtotal,
    required this.serviceFee,
    required this.taxes,
  });

  final double subtotal;
  final double serviceFee;
  final double taxes;

  double get totalPrice => subtotal + serviceFee + taxes;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.colors.lightBlue,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          PriceRow(label: AppLocalizations.of(context)!.paymentSubtotal, amount: subtotal),
          verticalSpace(12),
          PriceRow(label: AppLocalizations.of(context)!.paymentServiceFee, amount: serviceFee),
          verticalSpace(12),
          PriceRow(label: AppLocalizations.of(context)!.paymentTaxes, amount: taxes),
          verticalSpace(24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.paymentTotalPrice, style: TextStyles.font16WhiteBold(context)),
              Text(
                '\$${totalPrice.toStringAsFixed(2)}',
                style: TextStyles.font18OrangeBold,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

