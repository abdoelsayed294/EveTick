import 'package:evetick/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResultFavoriteIcon extends StatelessWidget {
  const ResultFavoriteIcon({
    super.key,
    required this.isFavorite,
    required this.onTap,
  });

  final bool isFavorite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Icon(
          Icons.favorite,
          size: 26.sp,
          color: isFavorite
              ? ColorsManager.orange
              : ColorsManager.lightGray.withValues(alpha: 0.9),
        ),
      ),
    );
  }
}
