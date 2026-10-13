import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/routing/routes.dart';
import 'package:evetick/core/widgets/app_error_view.dart';
import 'package:evetick/core/widgets/app_filter_button.dart';
import 'package:evetick/features/home/data/models/home_event_model.dart';
import 'package:evetick/features/search/logic/search_cubit.dart';
import 'package:evetick/features/search/logic/search_state.dart';
import 'package:evetick/features/search/ui/widgets/search_back_button.dart';
import 'package:evetick/features/search/ui/widgets/search_idle_view.dart';
import 'package:evetick/features/search/ui/widgets/search_input_field.dart';
import 'package:evetick/features/search/ui/widgets/search_results_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Search + results in one screen: trending / recent searches until the user
/// types (or picks a category), then the results.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.openFilters = false});

  /// Opened from the filter button of the home screen.
  final bool openFilters;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (!widget.openFilters) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    context.read<SearchCubit>().setQuery('');
  }

  /// Arrow and system back: close the filter panel, then leave the results,
  /// then close the screen.
  void _onBack() {
    final cubit = context.read<SearchCubit>();
    if (cubit.stepBack()) {
      if (!cubit.state.showResults) _controller.clear();
      _focusNode.unfocus();
    } else {
      Navigator.of(context).pop();
    }
  }

  /// Trending / recent chip: fill the box and search.
  void _useQuery(String query) {
    _controller.text = query;
    _controller.selection = TextSelection.collapsed(offset: query.length);
    _focusNode.unfocus();
    context.read<SearchCubit>().submitSearch(query);
  }

  Future<void> _openEvent(HomeEvent event) async {
    final cubit = context.read<SearchCubit>();
    cubit.saveRecent(_controller.text);
    await Navigator.of(context)
        .pushNamed(Routes.eventDetailsScreen, arguments: event.id);
    // The heart may have been changed on the details screen.
    cubit.refreshFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SearchCubit>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _onBack();
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                verticalSpace(16),
                BlocBuilder<SearchCubit, SearchState>(
                  buildWhen: (a, b) => a.isFilterOpen != b.isFilterOpen,
                  builder: (context, state) => Row(
                    children: [
                      SearchBackButton(onTap: _onBack),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: SearchInputField(
                          controller: _controller,
                          focusNode: _focusNode,
                          onChanged: cubit.setQuery,
                          onSubmitted: cubit.submitSearch,
                          onClear: _clear,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      AppFilterButton(
                        isActive: state.isFilterOpen,
                        onTap: cubit.toggleFilterPanel,
                      ),
                    ],
                  ),
                ),
                verticalSpace(16),
                Expanded(
                  child: BlocBuilder<SearchCubit, SearchState>(
                    builder: (context, state) => _buildBody(state, cubit),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(SearchState state, SearchCubit cubit) {
    switch (state.status) {
      case SearchStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case SearchStatus.error:
        return AppErrorView(message: state.errorMessage, onRetry: cubit.load);
      case SearchStatus.success:
        return SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.only(bottom: 24.h),
          child: state.showResults
              ? SearchResultsView(state: state, onEventTap: _openEvent)
              : SearchIdleView(state: state, onQuerySelected: _useQuery),
        );
    }
  }
}
