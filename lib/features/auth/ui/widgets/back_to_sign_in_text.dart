import 'package:evetick/core/helpers/extentions.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class BackToSignInText extends StatelessWidget {
  const BackToSignInText({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.pop();
      },
      child: Text(
        AppLocalizations.of(context)!.authBackToSignIn,
        style: TextStyles.font12OrangeMid,
      ),
    );
  }
}
