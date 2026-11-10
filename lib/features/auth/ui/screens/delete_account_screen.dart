import 'package:evetick/core/helpers/extentions.dart';
import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/core/widgets/filled_app_text_button.dart';
import 'package:evetick/features/auth/logic/delete_account_cubit/delete_account_cubit.dart';
import 'package:evetick/features/auth/ui/widgets/auth_background.dart';
import 'package:evetick/features/auth/ui/widgets/delete_account_bloc_listener.dart';
import 'package:evetick/features/auth/ui/widgets/delete_account_password.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DeleteAccountCubit>();
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
                        AppLocalizations.of(context)!.profileDeleteAccount,
                        style: TextStyles.font24WhiteBold(context),
                      ),
                    ),
                    verticalSpace(12),
                    Text(
                      AppLocalizations.of(context)!.deleteAccountWarning,
                      textAlign: TextAlign.center,
                      style: TextStyles.font14LightGrayRegular(context),
                    ),
                    if (!cubit.requiresPassword && cubit.usesGoogle) ...[
                      verticalSpace(12),
                      Text(
                        AppLocalizations.of(context)!.deleteAccountGoogleNotice,
                        textAlign: TextAlign.center,
                        style: TextStyles.font14LightGrayRegular(context),
                      ),
                    ],
                    verticalSpace(32),
                    const DeleteAccountBlocListener(),
                    const DeleteAccountPassword(),
                    verticalSpace(24),
                    FilledAppTextButton(
                      backgroundColor: ColorsManager.red,
                      buttonText: AppLocalizations.of(
                        context,
                      )!.profileDeleteAccount,
                      onPressed: () {
                        confirmThenDelete(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> confirmThenDelete(BuildContext context) async {
    final cubit = context.read<DeleteAccountCubit>();
    final l10n = AppLocalizations.of(context)!;
    if (!(cubit.formKey.currentState?.validate() ?? true)) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: dialogContext.colors.darkBlue,
        title: Text(
          l10n.deleteAccountConfirmTitle,
          style: TextStyles.font18WhiteBold(dialogContext),
        ),
        content: Text(
          l10n.deleteAccountConfirmMessage,
          style: TextStyles.font14LightGrayRegular(dialogContext),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(
              l10n.commonCancel,
              style: TextStyles.font16WhiteMid(dialogContext),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.commonDelete, style: TextStyles.font16RedMid),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      cubit.emitDeleteAccountStates(password: cubit.passwordController.text);
    }
  }
}
