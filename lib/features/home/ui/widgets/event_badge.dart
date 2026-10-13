import 'package:evetick/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// "TOP SELLING" (orange) / "TRENDING" (purple). Any other label is orange.
class EventBadge extends StatelessWidget {
  const EventBadge({super.key, required this.label});

  final String label;

  Color get _color {
    switch (label.trim().toUpperCase()) {
      case 'TRENDING':
        return ColorsManager.profileNotification;
      default:
        return ColorsManager.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: _color,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: ColorsManager.white,
        ),
      ),
    );
  }
}
