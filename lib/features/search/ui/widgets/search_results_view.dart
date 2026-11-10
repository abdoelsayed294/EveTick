import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/features/home/data/models/home_event_model.dart';
import 'package:evetick/features/search/logic/search_cubit.dart';
import 'package:evetick/features/search/logic/search_data.dart';
import 'package:evetick/features/search/ui/widgets/filter_panel.dart';
import 'package:evetick/features/search/ui/widgets/quick_filters_row.dart';
import 'package:evetick/features/search/ui/widgets/search_results_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evetick/l10n/app_localizations.dart';

class SearchResultsView extends StatelessWidget {
  const SearchResultsView({
    super.key,
    required this.data,
    required this.onEventTap,
  });

  final SearchData data;
  final ValueChanged<HomeEvent> onEventTap;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SearchCubit>();
    final results = data.results;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        QuickFiltersRow(
          filters: data.filters,
          onUpcoming: cubit.toggleUpcoming,
          onThisWeekend: cubit.toggleThisWeekend,
          onPriceLowToHigh: cubit.togglePriceLowToHigh,
        ),
        verticalSpace(16),
        if (data.isFilterOpen) ...[
          FilterPanel(
            filters: data.filters,
            categories: data.categories,
            onApply: cubit.applyFilters,
          ),
          verticalSpace(16),
        ],
        Text(
          AppLocalizations.of(context)!.homeResultsFound('${results.length}'),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: context.colors.white,
          ),
        ),
        verticalSpace(16),
        SearchResultsList(
          events: results,
          favoriteIds: data.favoriteIds,
          onEventTap: onEventTap,
          onFavoriteTap: (event) => cubit.toggleFavorite(event.id),
        ),
      ],
    );
  }
}
