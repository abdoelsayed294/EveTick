import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/text_styles.dart';

class SeatChip extends StatelessWidget {
  const SeatChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44.w,
      height: 31.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ColorsManager.hotBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorsManager.orange, width: 0.5),
      ),
      child: Text(label, style: TextStyles.font16OrangeBold),
    );
  }
}
