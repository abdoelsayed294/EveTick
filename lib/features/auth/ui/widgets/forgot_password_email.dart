import 'package:evetick/core/helpers/app_regex.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/widgets/app_text_form_field.dart';
import 'package:evetick/features/auth/logic/forgot_password_cubit/forgot_password_cubit.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPasswordEmail extends StatelessWidget {
  const ForgotPasswordEmail({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: context.read<ForgotPasswordCubit>().formKey,
      child: AppTextFormField(
        label: AppLocalizations.of(context)!.authEmailAddressLabel,
        hintText: AppLocalizations.of(context)!.authEmailPlaceholder,
        keyboardType: TextInputType.emailAddress,
        suffixIcon: Icon(
          Icons.email_outlined,
          color: ColorsManager.lightGray,
          size: 24.sp,
        ),
        validator: (value) {
          if (value == null ||
              value.trim().isEmpty ||
              !AppRegex.isEmailValid(value.trim())) {
            return 'Please enter a valid email';
          }
          return null;
        },
        controller: context.read<ForgotPasswordCubit>().emailController,
      ),
    );
  }
}
