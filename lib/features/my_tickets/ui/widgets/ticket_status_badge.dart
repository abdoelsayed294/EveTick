import 'package:evetick/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// "CONFIRMED" / "ACTIVE" (soft) or "COMPLETED" (solid orange).
class TicketStatusBadge extends StatelessWidget {
  const TicketStatusBadge({
    super.key,
    required this.label,
    required this.isSolid,
  });

  final String label;
  final bool isSolid;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: isSolid
            ? ColorsManager.orange
            : ColorsManager.orange.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: isSolid ? ColorsManager.white : ColorsManager.orange,
        ),
      ),
    );
  }
}
