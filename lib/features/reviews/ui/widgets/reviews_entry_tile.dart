import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evetick/l10n/app_localizations.dart';

class ReviewsEntryTile extends StatelessWidget {
  const ReviewsEntryTile({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: context.colors.lightBlue,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(Icons.star_rounded, color: ColorsManager.orange, size: 24.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.reviewsTitle,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: context.colors.white,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: context.colors.lightGray,
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }
}
