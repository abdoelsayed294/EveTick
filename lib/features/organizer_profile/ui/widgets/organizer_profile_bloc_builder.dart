import 'package:evetick/core/widgets/app_error_view.dart';
import 'package:evetick/features/organizer_profile/logic/organizer_profile_cubit.dart';
import 'package:evetick/features/organizer_profile/logic/organizer_profile_data.dart';
import 'package:evetick/features/organizer_profile/logic/organizer_profile_state.dart';
import 'package:evetick/features/organizer_profile/ui/widgets/organizer_back_button.dart';
import 'package:evetick/features/organizer_profile/ui/widgets/organizer_profile_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrganizerProfileBlocBuilder extends StatelessWidget {
  const OrganizerProfileBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrganizerProfileCubit, OrganizerProfileState>(
      buildWhen: (previous, current) =>
          current is Loading || current is Success || current is Error,
      builder: (context, state) {
        return Stack(
          children: [
            state.maybeWhen(
              success: (data) =>
                  OrganizerProfileContent(data: data as OrganizerProfileData),
              error: (error) => AppErrorView(message: error),
              orElse: () => const Center(child: CircularProgressIndicator()),
            ),
            const OrganizerBackButton(),
          ],
        );
      },
    );
  }
}
