import 'package:evetick/core/helpers/extentions.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:flutter/material.dart';

class HelpSupportAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const HelpSupportAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: context.colors.darkBlue,
      title: Text(title),
      centerTitle: true,
      titleTextStyle: TextStyles.font18DarkBlueBold(context),
      leading: GestureDetector(
        onTap: context.pop,
        child: Icon(Icons.arrow_back_ios, color: context.colors.white),
      ),
    );
  }
}
