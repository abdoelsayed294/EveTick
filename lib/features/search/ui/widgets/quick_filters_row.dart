import 'package:evetick/features/search/data/models/search_filters_model.dart';
import 'package:evetick/features/search/ui/widgets/quick_filter_chip.dart';
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
    return SizedBox(
      height: 44.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          QuickFilterChip(
            label: 'Upcoming',
            isSelected: filters.upcomingOnly,
            onTap: onUpcoming,
          ),
          SizedBox(width: 12.w),
          QuickFilterChip(
            label: 'This weekend',
            isSelected: filters.thisWeekend,
            onTap: onThisWeekend,
          ),
          SizedBox(width: 12.w),
          QuickFilterChip(
            label: 'Price: Low to High',
            isSelected: filters.priceLowToHigh,
            onTap: onPriceLowToHigh,
          ),
        ],
      ),
    );
  }
}
