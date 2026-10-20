import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/features/search/data/models/search_filters_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evetick/l10n/app_localizations.dart';

/// "Popularity | Date" switch inside the filter panel.
class SortSegmentedControl extends StatelessWidget {
  const SortSegmentedControl({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final SearchSort selected;
  final ValueChanged<SearchSort> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: context.colors.darkBlue,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          for (final sort in SearchSort.values)
            Expanded(
              child: GestureDetector(
                onTap: () => onSelected(sort),
                child: Container(
                  height: 40.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: sort == selected
                        ? ColorsManager.orange
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    sort == SearchSort.popularity
                        ? AppLocalizations.of(context)!.searchSortOptionsPopularity
                        : AppLocalizations.of(context)!.searchSortOptionsDate,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: context.colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
