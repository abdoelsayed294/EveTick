import 'package:evetick/core/helpers/date_formatter.dart';
import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/features/event_booking/data/models/confirmation_args.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderDetailsCard extends StatelessWidget {
  const OrderDetailsCard({super.key, required this.args});

  final ConfirmationArgs args;

  @override
  Widget build(BuildContext context) {
    final divider = Divider(color: context.colors.lightBlue, height: 1, thickness: 1);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.colors.thirdBlue,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          _DetailRow(
            label: 'Order ID',
            value: Text(args.displayOrderId, style: TextStyles.font16WhiteMid(context)),
          ),
          verticalSpace(16),
          divider,
          verticalSpace(16),
          _DetailRow(
            label: 'Total Paid',
            value: Text(
              '\$${args.totalPaid.toStringAsFixed(2)}',
              style: TextStyles.font18OrangeBold,
            ),
          ),
          verticalSpace(16),
          divider,
          verticalSpace(16),
          _DetailRow(
            label: 'Date',
            value: Text(formatDate(args.paidAt), style: TextStyles.font16WhiteMid(context)),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final Widget value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyles.font12LightGrayRegular(context)),
        value,
      ],
    );
  }
}
