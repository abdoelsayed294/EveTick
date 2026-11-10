import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/widgets/app_text_form_field.dart';
import 'package:evetick/features/auth/logic/delete_account_cubit/delete_account_cubit.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeleteAccountPassword extends StatefulWidget {
  const DeleteAccountPassword({super.key});

  @override
  State<DeleteAccountPassword> createState() => _DeleteAccountPasswordState();
}

class _DeleteAccountPasswordState extends State<DeleteAccountPassword> {
  bool isObscureText = true;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DeleteAccountCubit>();
    return Form(
      key: cubit.formKey,
      child: cubit.requiresPassword
          ? AppTextFormField(
              label: AppLocalizations.of(context)!.authPasswordLabel,
              hintText: AppLocalizations.of(
                context,
              )!.deleteAccountPasswordPrompt,
              isObscureText: isObscureText,
              controller: cubit.passwordController,
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    isObscureText = !isObscureText;
                  });
                },
                child: Icon(
                  isObscureText ? Icons.visibility_off : Icons.visibility,
                  color: ColorsManager.lightGray,
                  size: 24.sp,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            )
          : const SizedBox.shrink(),
    );
  }
}
