import 'package:evetick/core/widgets/app_filter_button.dart';
import 'package:evetick/features/search/logic/search_cubit.dart';
import 'package:evetick/features/search/logic/search_state.dart';
import 'package:evetick/features/search/ui/widgets/search_back_button.dart';
import 'package:evetick/features/search/ui/widgets/search_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchTopBar extends StatelessWidget {
  const SearchTopBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onBack,
    required this.onClear,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onBack;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SearchCubit>();

    return BlocBuilder<SearchCubit, SearchState>(
      buildWhen: (previous, current) => current is Success,
      builder: (context, state) {
        return Row(
          children: [
            SearchBackButton(onTap: onBack),
            SizedBox(width: 4.w),
            Expanded(
              child: SearchInputField(
                controller: controller,
                focusNode: focusNode,
                onChanged: cubit.setQuery,
                onSubmitted: cubit.submitSearch,
                onClear: onClear,
              ),
            ),
            SizedBox(width: 12.w),
            AppFilterButton(
              isActive: cubit.data.isFilterOpen,
              onTap: cubit.toggleFilterPanel,
            ),
          ],
        );
      },
    );
  }
}
