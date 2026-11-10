import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class TermsHeader extends StatelessWidget {
  const TermsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.termsSubtitle, style: TextStyles.font20WhiteBold(context)),
        verticalSpace(6),
        Text(
          l10n.termsLastUpdated(l10n.termsLastUpdatedValue),
          style: TextStyles.font12OrangeRegular,
        ),
      ],
    );
  }
}
