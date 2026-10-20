import 'package:evetick/core/widgets/app_error_view.dart';
import 'package:evetick/features/following_organizers/data/models/followed_organizer_model.dart';
import 'package:evetick/features/following_organizers/logic/following_organizers_cubit.dart';
import 'package:evetick/features/following_organizers/logic/following_organizers_state.dart';
import 'package:evetick/features/following_organizers/ui/widgets/following_organizers_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FollowingOrganizersBlocBuilder extends StatelessWidget {
  const FollowingOrganizersBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FollowingOrganizersCubit, FollowingOrganizersState>(
      buildWhen: (previous, current) =>
          current is Loading || current is Success || current is Error,
      builder: (context, state) {
        return state.maybeWhen(
          success: (data) => FollowingOrganizersList(
            organizers: data as List<FollowedOrganizer>,
          ),
          error: (error) => AppErrorView(
            message: error,
            onRetry: context.read<FollowingOrganizersCubit>().load,
          ),
          orElse: () => const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
