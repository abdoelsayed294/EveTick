import 'package:evetick/core/helpers/extentions.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class TermsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBack;

  const TermsAppBar({super.key, this.showBack = true});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: context.colors.darkBlue,
      title: Text(AppLocalizations.of(context)!.termsTitle),
      centerTitle: true,
      titleTextStyle: TextStyles.font18DarkBlueBold(context),
      automaticallyImplyLeading: false,
      leading: showBack
          ? GestureDetector(
              onTap: context.pop,
              child: Icon(Icons.arrow_back_ios, color: context.colors.white),
            )
          : null,
    );
  }
}
