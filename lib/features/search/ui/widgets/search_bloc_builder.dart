import 'package:evetick/core/widgets/app_error_view.dart';
import 'package:evetick/features/home/data/models/home_event_model.dart';
import 'package:evetick/features/search/logic/search_cubit.dart';
import 'package:evetick/features/search/logic/search_data.dart';
import 'package:evetick/features/search/logic/search_state.dart';
import 'package:evetick/features/search/ui/widgets/search_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBlocBuilder extends StatelessWidget {
  const SearchBlocBuilder({
    super.key,
    required this.onEventTap,
    required this.onQuerySelected,
  });

  final ValueChanged<HomeEvent> onEventTap;
  final ValueChanged<String> onQuerySelected;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      buildWhen: (previous, current) =>
          current is Loading || current is Success || current is Error,
      builder: (context, state) {
        return state.maybeWhen(
          success: (data) => SearchContent(
            data: data as SearchData,
            onEventTap: onEventTap,
            onQuerySelected: onQuerySelected,
          ),
          error: (error) => AppErrorView(
            message: error,
            onRetry: context.read<SearchCubit>().load,
          ),
          orElse: () => const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
