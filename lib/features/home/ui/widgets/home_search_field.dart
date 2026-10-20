import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/widgets/app_filter_button.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeSearchField extends StatelessWidget {
  const HomeSearchField({
    super.key,
    required this.onSearchTap,
    required this.onFilterTap,
  });

  final VoidCallback onSearchTap;
  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onSearchTap,
            child: Container(
              height: 52.w,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: colors.lightBlue,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: colors.lightGray),
                  SizedBox(width: 12.w),
                  Text(
                    AppLocalizations.of(context)!.homeSearchPlaceholder,
                    style: TextStyle(color: colors.lightGray, fontSize: 14.sp),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        AppFilterButton(onTap: onFilterTap),
      ],
    );
  }
}
