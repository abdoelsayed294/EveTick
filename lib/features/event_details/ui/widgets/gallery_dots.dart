import 'package:evetick/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GalleryDots extends StatelessWidget {
  const GalleryDots({super.key, required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: EdgeInsets.symmetric(horizontal: 3.w),
            width: i == current ? 18.w : 6.w,
            height: 6.h,
            decoration: BoxDecoration(
              color: i == current
                  ? ColorsManager.orange
                  : ColorsManager.white.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(3.r),
            ),
          ),
      ],
    );
  }
}
