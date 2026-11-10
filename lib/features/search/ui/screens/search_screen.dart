import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/routing/routes.dart';
import 'package:evetick/features/home/data/models/home_event_model.dart';
import 'package:evetick/features/search/logic/search_cubit.dart';
import 'package:evetick/features/search/ui/widgets/search_bloc_builder.dart';
import 'package:evetick/features/search/ui/widgets/search_top_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.openFilters = false});

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

  void _onBack() {
    final cubit = context.read<SearchCubit>();
    if (cubit.stepBack()) {
      if (!cubit.data.showResults) _controller.clear();
      _focusNode.unfocus();
    } else {
      Navigator.of(context).pop();
    }
  }

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
    cubit.refreshFavorites();
  }

  @override
  Widget build(BuildContext context) {
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
                SearchTopBar(
                  controller: _controller,
                  focusNode: _focusNode,
                  onBack: _onBack,
                  onClear: _clear,
                ),
                verticalSpace(16),
                Expanded(
                  child: SearchBlocBuilder(
                    onEventTap: _openEvent,
                    onQuerySelected: _useQuery,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
