import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LegendItem extends StatelessWidget {
  LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.h,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        horizontalSpace(8),
        Text(label, style: TextStyles.font12LightGrayRegular(context)),
      ],
    );
  }
}
