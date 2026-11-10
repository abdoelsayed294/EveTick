import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:evetick/features/event_booking/ui/widgets/step_indicator.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.onPrevious,
    required this.title,
    required this.stepNum,
    required this.stepTitles,
  });

  final VoidCallback onPrevious;
  final String title;
  final int stepNum;
  final List<String> stepTitles;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: context.colors.darkBlue,
      centerTitle: true,

      title: Text(
        title,
        style: TextStyles.font18WhiteBold(context),
      ),

      leading: InkWell(
        onTap: onPrevious,
        child: Icon(
          Icons.arrow_back_ios,
          color: ColorsManager.white,
        ),
      ),

      bottom: PreferredSize(
        preferredSize: Size.fromHeight(55.h),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 8.h,
          ),
          child: StepIndicator(
            stepNum: stepNum,
            stepTitles: stepTitles,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + 55.h,
      );
}