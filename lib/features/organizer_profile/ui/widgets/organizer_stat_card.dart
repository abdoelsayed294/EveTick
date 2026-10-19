import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// "128  Events Hosted" box.
class OrganizerStatCard extends StatelessWidget {
  const OrganizerStatCard({super.key, required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.lightBlue,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.lightGray.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: colors.white,
            ),
          ),
          SizedBox(height: 4.h),
          Text(label, style: TextStyle(fontSize: 14.sp, color: colors.lightGray)),
        ],
      ),
    );
  }
}
