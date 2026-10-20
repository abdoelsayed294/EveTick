import 'package:evetick/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evetick/l10n/app_localizations.dart';

class LoadMoreReviews extends StatelessWidget {
  const LoadMoreReviews({
    super.key,
    required this.isLoading,
    required this.onTap,
    this.error,
  });

  final bool isLoading;
  final VoidCallback onTap;
  final String? error;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: ColorsManager.orange,
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        if (error != null)
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Text(
              error!,
              textAlign: TextAlign.center,
              style: TextStyle(color: ColorsManager.red, fontSize: 14.sp),
            ),
          ),
        TextButton(
          onPressed: onTap,
          child: Text(
            AppLocalizations.of(context)!.commonLoadMoreReviews,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: ColorsManager.orange,
            ),
          ),
        ),
      ],
    );
  }
}
