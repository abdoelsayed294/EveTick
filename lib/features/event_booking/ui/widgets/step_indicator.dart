import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StepIndicator extends StatelessWidget {
  const StepIndicator({
    super.key,
    required this.stepNum,
  });

  final int stepNum;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Step $stepNum OF 3',
              style: TextStyles.font12OrangeRegular,
            ),
            Text(
              _getStepTitle(),
              style: TextStyles.font12LightGrayRegular(context),
            ),
          ],
        ),

        verticalSpace(8),

        LinearProgressIndicator(
          backgroundColor: context.colors.darkGray,
          value: stepNum / 3,
          color: ColorsManager.orange,
          minHeight: 7.h,
          borderRadius: BorderRadius.circular(12.r),
        ),
      ],
    );
  }

  String _getStepTitle() {
    switch (stepNum) {
      case 1:
        return 'Ticket Selection';
      case 2:
        return 'Seat Selection';
      case 3:
        return 'Checkout';
      default:
        return '';
    }
  }
}