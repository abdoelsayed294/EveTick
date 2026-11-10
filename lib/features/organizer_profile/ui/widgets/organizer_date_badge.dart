import 'package:evetick/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class OrganizerDateBadge extends StatelessWidget {
  const OrganizerDateBadge({super.key, required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: ColorsManager.defaultWhite.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            DateFormat('MMM').format(date).toUpperCase(),
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: ColorsManager.darkGray,
            ),
          ),
          Text(
            '${date.day}',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: ColorsManager.darkBlue,
            ),
          ),
        ],
      ),
    );
  }
}
