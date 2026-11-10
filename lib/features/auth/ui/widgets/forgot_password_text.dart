import 'package:evetick/core/helpers/extentions.dart';
import 'package:evetick/core/routing/routes.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/features/auth/logic/login_cubit/login_cubit.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordText extends StatelessWidget {
  const ForgotPasswordText({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: InkWell(
        onTap: () {
          context.pushNamed(
            Routes.forgotPasswordScreen,
            arguments: context.read<LoginCubit>().emailController.text,
          );
        },
        child: Text(
          AppLocalizations.of(context)!.authForgotPassword,
          style: TextStyles.font12OrangeMid,
        ),
      ),
    );
  }
}
