import 'package:evetick/core/helpers/date_formatter.dart';
import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/features/event_booking/data/models/confirmation_args.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evetick/features/event_booking/ui/widgets/confirmation_widgets/order_detail_row.dart';

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
          OrderDetailRow(
            label: 'Order ID',
            value: Text(args.displayOrderId, style: TextStyles.font16WhiteMid(context)),
          ),
          verticalSpace(16),
          divider,
          verticalSpace(16),
          OrderDetailRow(
            label: 'Total Paid',
            value: Text(
              '\$${args.totalPaid.toStringAsFixed(2)}',
              style: TextStyles.font18OrangeBold,
            ),
          ),
          verticalSpace(16),
          divider,
          verticalSpace(16),
          OrderDetailRow(
            label: 'Date',
            value: Text(formatDate(args.paidAt), style: TextStyles.font16WhiteMid(context)),
          ),
        ],
      ),
    );
  }
}
