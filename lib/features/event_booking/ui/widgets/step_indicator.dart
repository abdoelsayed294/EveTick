import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evetick/l10n/app_localizations.dart';

class StepIndicator extends StatelessWidget {
  const StepIndicator({
    super.key,
    required this.stepNum,
    required this.stepTitles,
  });

  final int stepNum;

  /// One title per step; its length is the total number of steps.
  final List<String> stepTitles;

  int get _total => stepTitles.length;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.ticketsStepIndicator('$stepNum', '$_total'),
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
          value: stepNum / _total,
          color: ColorsManager.orange,
          minHeight: 7.h,
          borderRadius: BorderRadius.circular(12.r),
        ),
      ],
    );
  }

  String _getStepTitle() {
    final index = stepNum - 1;
    return index >= 0 && index < stepTitles.length ? stepTitles[index] : '';
  }
}
