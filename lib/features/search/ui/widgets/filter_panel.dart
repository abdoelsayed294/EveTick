import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/core/widgets/filled_app_text_button.dart';
import 'package:evetick/features/search/data/models/search_filters_model.dart';
import 'package:evetick/features/search/ui/widgets/search_chip.dart';
import 'package:evetick/features/search/ui/widgets/sort_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// "Filter & Refine": sort + category. Nothing changes until the user
/// presses "Apply Filters".
class FilterPanel extends StatefulWidget {
  const FilterPanel({
    super.key,
    required this.filters,
    required this.categories,
    required this.onApply,
  });

  final SearchFilters filters;
  final List<String> categories;
  final ValueChanged<SearchFilters> onApply;

  @override
  State<FilterPanel> createState() => _FilterPanelState();
}

class _FilterPanelState extends State<FilterPanel> {
  late SearchSort _sort = widget.filters.sort;
  late String? _category = widget.filters.category;

  void _apply() {
    widget.onApply(
      widget.filters.copyWith(
        sort: _sort,
        category: _category,
        clearCategory: _category == null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.lightBlue,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Filter & Refine', style: TextStyles.font18WhiteBold(context)),
          verticalSpace(16),
          Text('Sort by', style: TextStyles.font16LightGrayMid(context)),
          verticalSpace(8),
          SortSegmentedControl(
            selected: _sort,
            onSelected: (sort) => setState(() => _sort = sort),
          ),
          verticalSpace(16),
          Text('Category', style: TextStyles.font16LightGrayMid(context)),
          verticalSpace(8),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              for (final category in widget.categories)
                SearchChip(
                  label: category,
                  backgroundColor: colors.darkBlue,
                  isSelected: category == _category,
                  // tap the selected one again to clear it
                  onTap: () => setState(
                    () => _category = category == _category ? null : category,
                  ),
                ),
            ],
          ),
          verticalSpace(24),
          FilledAppTextButton(
            buttonText: 'Apply Filters',
            buttonWidth: double.infinity,
            onPressed: _apply,
          ),
        ],
      ),
    );
  }
}
