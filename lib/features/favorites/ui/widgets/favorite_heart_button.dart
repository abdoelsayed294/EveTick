import 'package:evetick/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Filled orange heart on a dark rounded square (tap = remove).
class FavoriteHeartButton extends StatelessWidget {
  const FavoriteHeartButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: ColorsManager.secondryBlue.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(Icons.favorite, size: 22.sp, color: ColorsManager.orange),
      ),
    );
  }
}
