import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HighDemandBadge extends StatelessWidget {
  const HighDemandBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: ColorsManager.orange.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_fire_department,
            size: 16.sp,
            color: ColorsManager.orange,
          ),
          SizedBox(width: 4.w),
          Text(
            AppLocalizations.of(context)!.homeBadgesHighDemand,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: ColorsManager.orange,
            ),
          ),
        ],
      ),
    );
  }
}
