import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TermsRefundNote extends StatelessWidget {
  const TermsRefundNote({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final style = TextStyles.font14LightGrayRegular(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: ColorsManager.darkGray,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: RichText(
        text: TextSpan(
          style: style,
          children: [
            TextSpan(text: l10n.termsRefundNotePrefix),
            TextSpan(
              text: l10n.termsRefundPolicyLink,
              style: style.copyWith(color: ColorsManager.orange),
            ),
            TextSpan(text: l10n.termsRefundNoteSuffix),
          ],
        ),
      ),
    );
  }
}
