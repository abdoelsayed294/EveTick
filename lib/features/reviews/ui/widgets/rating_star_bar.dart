import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';

class RatingStarBar extends StatelessWidget {
  const RatingStarBar({super.key, required this.star, required this.fraction});

  final int star;
  final double fraction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 16.w,
          child: Text(
            '$star',
            style: TextStyle(fontSize: 14.sp, color: context.colors.white),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: LinearProgressIndicator(
              value: fraction,
              minHeight: 8.h,
              color: ColorsManager.orange,
              backgroundColor: context.colors.thirdBlue,
            ),
          ),
        ),
      ],
    );
  }
}
