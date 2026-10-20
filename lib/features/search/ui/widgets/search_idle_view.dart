import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/features/search/logic/search_cubit.dart';
import 'package:evetick/features/search/logic/search_data.dart';
import 'package:evetick/features/search/ui/widgets/filter_panel.dart';
import 'package:evetick/features/search/ui/widgets/recent_searches_section.dart';
import 'package:evetick/features/search/ui/widgets/trending_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchIdleView extends StatelessWidget {
  const SearchIdleView({
    super.key,
    required this.data,
    required this.onQuerySelected,
  });

  final SearchData data;
  final ValueChanged<String> onQuerySelected;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SearchCubit>();
    final trending = data.trending;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (trending.isNotEmpty) ...[
          TrendingSection(titles: trending, onSelected: onQuerySelected),
          verticalSpace(24),
        ],
        if (data.recentSearches.isNotEmpty) ...[
          RecentSearchesSection(
            searches: data.recentSearches,
            onSelected: onQuerySelected,
            onClearAll: cubit.clearRecent,
          ),
          verticalSpace(24),
        ],
        if (data.isFilterOpen)
          FilterPanel(
            filters: data.filters,
            categories: data.categories,
            onApply: cubit.applyFilters,
          ),
      ],
    );
  }
}
