import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/widgets/filled_app_text_button.dart';
import 'package:evetick/core/widgets/outline_app_text_button.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TermsActionBar extends StatelessWidget {
  final VoidCallback onDecline;
  final VoidCallback onAgree;

  const TermsActionBar({
    super.key,
    required this.onDecline,
    required this.onAgree,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        OutlineAppTextButton(
          buttonText: l10n.termsDecline,
          buttonWidth: 118.w,
          borderRadius: 12,
          onPressed: onDecline,
        ),
        horizontalSpace(12),
        FilledAppTextButton(
          buttonText: l10n.termsAgreeAndContinue,
          buttonWidth: 213.w,
          onPressed: onAgree,
        ),
      ],
    );
  }
}
