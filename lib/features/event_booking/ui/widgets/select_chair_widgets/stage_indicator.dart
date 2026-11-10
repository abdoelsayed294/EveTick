import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evetick/features/event_booking/ui/widgets/select_chair_widgets/stage_clipper.dart';

class StageIndicator extends StatelessWidget {
  const StageIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: StageClipper(),
      child: Container(
        width: 300.w,
        height: 48.h,
        color: ColorsManager.lightBlue,
        alignment: Alignment.center,
        child: Text('STAGE', style: TextStyles.font16WhiteRegular(context)),
      ),
    );
  }
}
