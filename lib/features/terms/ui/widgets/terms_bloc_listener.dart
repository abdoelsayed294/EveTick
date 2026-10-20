import 'package:evetick/core/services/toast/app_toast.dart';
import 'package:evetick/core/helpers/extentions.dart';
import 'package:evetick/features/terms/logic/terms_cubit.dart';
import 'package:evetick/features/terms/logic/terms_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TermsBlocListener extends StatelessWidget {
  final Widget child;

  const TermsBlocListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<TermsCubit, TermsState>(
      listenWhen: (previous, current) =>
          current is TermsSaved || current is TermsError,
      listener: (context, state) {
        state.whenOrNull(
          saved: () => context.pop(),
          error: (error) => AppToast.error(error),
        );
      },
      child: child,
    );
  }
}
