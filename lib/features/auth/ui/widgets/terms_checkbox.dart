import 'package:evetick/core/helpers/extentions.dart';
import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/routing/routes.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/features/auth/logic/signup_cubit/signup_cubit.dart';
import 'package:evetick/features/terms/data/models/terms_mode.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TermsCheckbox extends StatelessWidget {
  const TermsCheckbox({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SignupCubit>();
    final l10n = AppLocalizations.of(context)!;

    return ValueListenableBuilder<bool>(
      valueListenable: cubit.acceptedTerms,
      builder: (context, accepted, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 24.w,
                  height: 24.h,
                  child: Checkbox(
                    value: accepted,
                    activeColor: ColorsManager.orange,
                    checkColor: ColorsManager.defaultWhite,
                    side: BorderSide(color: context.colors.lightGray, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    onChanged: (value) => cubit.setTermsAccepted(value ?? false),
                  ),
                ),
                horizontalSpace(12),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      style: TextStyles.font12LightGrayRegular(context),
                      children: [
                        TextSpan(text: l10n.termsCheckboxPrefix),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.baseline,
                          baseline: TextBaseline.alphabetic,
                          child: GestureDetector(
                            onTap: () => _openTerms(context, cubit),
                            child: Text(
                              l10n.termsTitle,
                              style: TextStyles.font12OrangeMid,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ValueListenableBuilder<bool>(
              valueListenable: cubit.showTermsError,
              builder: (context, showError, _) {
                if (!showError) return const SizedBox.shrink();
                return Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Text(
                    l10n.termsCheckboxRequired,
                    style: TextStyle(color: ColorsManager.red, fontSize: 12.sp),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _openTerms(BuildContext context, SignupCubit cubit) async {
    final result = await context.pushNamed(
      Routes.termsScreen,
      arguments: TermsMode.signup,
    );
    if (result is bool) cubit.setTermsAccepted(result);
  }
}
