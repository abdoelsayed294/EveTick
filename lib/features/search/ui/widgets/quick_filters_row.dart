import 'package:evetick/features/search/data/models/search_filters_model.dart';
import 'package:evetick/features/search/ui/widgets/quick_filter_chip.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuickFiltersRow extends StatelessWidget {
  const QuickFiltersRow({
    super.key,
    required this.filters,
    required this.onUpcoming,
    required this.onThisWeekend,
    required this.onPriceLowToHigh,
  });

  final SearchFilters filters;
  final VoidCallback onUpcoming;
  final VoidCallback onThisWeekend;
  final VoidCallback onPriceLowToHigh;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      height: 44.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          QuickFilterChip(
            label: l10n.homeSortOptionsUpcoming,
            isSelected: filters.upcomingOnly,
            onTap: onUpcoming,
          ),
          SizedBox(width: 12.w),
          QuickFilterChip(
            label: l10n.homeSortOptionsThisWeekend,
            isSelected: filters.thisWeekend,
            onTap: onThisWeekend,
          ),
          SizedBox(width: 12.w),
          QuickFilterChip(
            label: l10n.homeSortOptionsPriceLowToHigh,
            isSelected: filters.priceLowToHigh,
            onTap: onPriceLowToHigh,
          ),
        ],
      ),
    );
  }
}
