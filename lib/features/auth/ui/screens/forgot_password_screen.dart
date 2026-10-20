import 'package:evetick/core/helpers/extentions.dart';
import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/core/widgets/filled_app_text_button.dart';
import 'package:evetick/features/auth/logic/forgot_password_cubit/forgot_password_cubit.dart';
import 'package:evetick/features/auth/ui/widgets/auth_background.dart';
import 'package:evetick/features/auth/ui/widgets/back_to_sign_in_text.dart';
import 'package:evetick/features/auth/ui/widgets/forgot_password_bloc_listener.dart';
import 'package:evetick/features/auth/ui/widgets/forgot_password_email.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const LoginBackground(),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 16.w),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Navigator.of(context).canPop()
                          ? InkWell(
                              onTap: () {
                                context.pop();
                              },
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: context.colors.white,
                                size: 24.sp,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    verticalSpace(24),
                    Align(
                      alignment: Alignment.center,
                      child: Theme.of(context).brightness == Brightness.dark
                          ? SvgPicture.asset('assets/svgs/dark_logo.svg')
                          : SvgPicture.asset('assets/svgs/light_logo.svg'),
                    ),
                    verticalSpace(24),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        AppLocalizations.of(context)!.authForgotPasswordTitle,
                        style: TextStyles.font24WhiteBold(context),
                      ),
                    ),
                    verticalSpace(12),
                    Text(
                      AppLocalizations.of(context)!.authForgotPasswordSubtitle,
                      textAlign: TextAlign.center,
                      style: TextStyles.font14LightGrayRegular(context),
                    ),
                    verticalSpace(32),
                    const ForgotPasswordBlocListener(),
                    const ForgotPasswordEmail(),
                    verticalSpace(24),
                    FilledAppTextButton(
                      buttonText: AppLocalizations.of(context)!.authSendResetLink,
                      onPressed: () {
                        validateThenSendResetLink(context);
                      },
                    ),
                    verticalSpace(32),
                    const BackToSignInText(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void validateThenSendResetLink(BuildContext context) {
    final cubit = context.read<ForgotPasswordCubit>();
    if (cubit.formKey.currentState!.validate()) {
      cubit.emitForgotPasswordStates(email: cubit.emailController.text);
    }
  }
}
