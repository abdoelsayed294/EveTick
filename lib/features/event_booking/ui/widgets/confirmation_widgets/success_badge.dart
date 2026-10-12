import 'package:evetick/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SuccessBadge extends StatelessWidget {
  const SuccessBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 128.w,
      height: 128.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ColorsManager.gray3.withValues(alpha: 0.3),
      ),
      child: Container(
        width: 96.w,
        height: 96.w,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: ColorsManager.orange,
        ),
        child: Icon(Icons.check_rounded, color: ColorsManager.white, size: 56.sp),
      ),
    );
  }
}
