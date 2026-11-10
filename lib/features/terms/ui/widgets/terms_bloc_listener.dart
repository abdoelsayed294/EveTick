import 'package:evetick/core/services/toast/app_toast.dart';
import 'package:evetick/core/helpers/extentions.dart';
import 'package:evetick/core/routing/routes.dart';
import 'package:evetick/features/terms/data/models/terms_mode.dart';
import 'package:evetick/features/terms/logic/terms_cubit.dart';
import 'package:evetick/features/terms/logic/terms_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TermsBlocListener extends StatelessWidget {
  final Widget child;
  final TermsMode mode;

  const TermsBlocListener({super.key, required this.child, required this.mode});

  @override
  Widget build(BuildContext context) {
    return BlocListener<TermsCubit, TermsState>(
      listenWhen: (previous, current) =>
          current is TermsSaved || current is TermsError,
      listener: (context, state) {
        state.whenOrNull(
          saved: () {
            if (mode == TermsMode.firstLogin) {
              context.pushReplacedNamed(Routes.appStartScreen);
            } else {
              context.pop();
            }
          },
          error: (error) => AppToast.error(error),
        );
      },
      child: child,
    );
  }
}
