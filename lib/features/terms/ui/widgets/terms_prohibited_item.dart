import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TermsProhibitedItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const TermsProhibitedItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: ColorsManager.orange, size: 24.sp),
        horizontalSpace(12),
        Expanded(
          child: Text(
            text,
            style: TextStyles.font14LightGrayRegular(context),
          ),
        ),
      ],
    );
  }
}
