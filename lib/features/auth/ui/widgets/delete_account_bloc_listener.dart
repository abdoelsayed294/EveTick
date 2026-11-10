import 'package:evetick/core/helpers/extentions.dart';
import 'package:evetick/core/routing/routes.dart';
import 'package:evetick/core/services/toast/app_toast.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/features/auth/logic/delete_account_cubit/delete_account_cubit.dart';
import 'package:evetick/features/auth/logic/delete_account_cubit/delete_account_state.dart';
import 'package:evetick/features/auth/ui/widgets/error_banner.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteAccountBlocListener extends StatelessWidget {
  const DeleteAccountBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeleteAccountCubit, DeleteAccountState>(
      listenWhen: (previous, current) =>
          current is Loading || current is Success || current is Error,
      listener: (context, state) {
        state.whenOrNull(
          success: (data) {
            AppToast.success(AppLocalizations.of(context)!.deleteAccountSuccess);
            context.pushNamedAndRemoveUntil(
              Routes.appStartScreen,
              predicate: (route) => false,
            );
          },
        );
      },
      builder: (context, state) {
        if (state is Loading) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Center(
              child: CircularProgressIndicator(color: ColorsManager.orange),
            ),
          );
        }
        final errorMessage = state.whenOrNull(error: (error) => error);
        return ErrorBanner(message: errorMessage);
      },
    );
  }
}
