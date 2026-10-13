import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// A terms paragraph. The brand name inside the text is highlighted in orange.
class TermsBodyText extends StatelessWidget {
  final String text;

  const TermsBodyText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final brand = AppLocalizations.of(context)!.onboardingAppName;
    final style = TextStyles.font14LightGrayRegular(context);
    final parts = text.split(brand);

    return RichText(
      text: TextSpan(
        style: style,
        children: [
          for (var i = 0; i < parts.length; i++) ...[
            TextSpan(text: parts[i]),
            if (i < parts.length - 1)
              TextSpan(
                text: brand,
                style: style.copyWith(color: ColorsManager.orange),
              ),
          ],
        ],
      ),
    );
  }
}
