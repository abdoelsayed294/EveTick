import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EventInfoTile extends StatelessWidget {
  const EventInfoTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            color: context.colors.lightBlue,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(icon, color: ColorsManager.orange, size: 24.sp),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: context.colors.white,
                ),
              ),
              if (subtitle != null && subtitle!.isNotEmpty) ...[
                SizedBox(height: 2.h),
                Text(
                  subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: context.colors.lightGray,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (actionText != null && onAction != null)
          TextButton(
            onPressed: onAction,
            child: Text(
              actionText!,
              style: TextStyle(fontSize: 12.sp, color: ColorsManager.orange),
            ),
          ),
      ],
    );
  }
}
