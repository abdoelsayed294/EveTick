import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/features/search/logic/search_cubit.dart';
import 'package:evetick/features/search/logic/search_state.dart';
import 'package:evetick/features/search/ui/widgets/filter_panel.dart';
import 'package:evetick/features/search/ui/widgets/recent_searches_section.dart';
import 'package:evetick/features/search/ui/widgets/trending_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Search page before the user typed anything:
/// trending, recent searches and (when open) the filter panel.
class SearchIdleView extends StatelessWidget {
  const SearchIdleView({
    super.key,
    required this.state,
    required this.onQuerySelected,
  });

  final SearchState state;
  final ValueChanged<String> onQuerySelected;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SearchCubit>();
    final trending = state.trending;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (trending.isNotEmpty) ...[
          TrendingSection(titles: trending, onSelected: onQuerySelected),
          verticalSpace(24),
        ],
        if (state.recentSearches.isNotEmpty) ...[
          RecentSearchesSection(
            searches: state.recentSearches,
            onSelected: onQuerySelected,
            onClearAll: cubit.clearRecent,
          ),
          verticalSpace(24),
        ],
        if (state.isFilterOpen)
          FilterPanel(
            filters: state.filters,
            categories: state.categories,
            onApply: cubit.applyFilters,
          ),
      ],
    );
  }
}
