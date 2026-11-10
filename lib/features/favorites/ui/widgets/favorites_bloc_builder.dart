import 'package:evetick/core/widgets/app_error_view.dart';
import 'package:evetick/features/favorites/logic/favorites_cubit.dart';
import 'package:evetick/features/favorites/logic/favorites_state.dart';
import 'package:evetick/features/favorites/ui/widgets/favorites_list.dart';
import 'package:evetick/features/home/data/models/home_event_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesBlocBuilder extends StatelessWidget {
  const FavoritesBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      buildWhen: (previous, current) =>
          current is Loading || current is Success || current is Error,
      builder: (context, state) {
        return state.maybeWhen(
          success: (data) => FavoritesList(events: data as List<HomeEvent>),
          error: (error) => AppErrorView(
            message: error,
            onRetry: context.read<FavoritesCubit>().load,
          ),
          orElse: () => const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
