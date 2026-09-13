import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/features/event_booking/ui/widgets/quantity_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TicketTypeContainer extends StatelessWidget {
  const TicketTypeContainer({
    super.key,
    required this.name,
    required this.description,
    required this.price,
    this.isSoldOut = false,
  });

  final String name;
  final String description;
  final double price;
  final bool isSoldOut;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isSoldOut ? context.colors.thirdBlue : context.colors.lightBlue,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: TextStyles.font16WhiteBold(context)),
          verticalSpace(8),
          Text(
            description,
            softWrap: true,
            style: TextStyles.font12LightGrayRegular(context),
          ),
          verticalSpace(8),
          Text(
            '\$$price',
            style: isSoldOut
                ? TextStyles.font18DarkGrayBold(context)
                : TextStyles.font16OrangeBold,
          ),
          if (isSoldOut == false) ...[
            verticalSpace(24),
            Divider(color: context.colors.darkBlue, height: 1, thickness: 1),
            verticalSpace(24),
            Align(alignment: Alignment.centerRight, child: QuantitySelector()),
          ],
        ],
      ),
    );
  }
}
