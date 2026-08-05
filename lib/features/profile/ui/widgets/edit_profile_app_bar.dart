import 'package:evetick/core/helpers/extentions.dart';
import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EditProfileAppBar extends StatelessWidget {
  final bool isEditing;
  final bool isLoading;
  final VoidCallback onActionPressed;

  const EditProfileAppBar({
    super.key,
    required this.isEditing,
    this.isLoading = false,
    required this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.profilePersonalInfoTitle),
      centerTitle: true,
      titleTextStyle: TextStyles.font18DarkBlueBold(context),
      leading: GestureDetector(
        onTap: context.pop,
        child: Icon(Icons.arrow_back_ios, color: context.colors.white),
      ),
      actions: [
        GestureDetector(
          onTap: onActionPressed,
          child: isEditing
              ? isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: ColorsManager.orange,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(AppLocalizations.of(context)!.profileSave, style: TextStyles.font16OrangeRegular)
              : SvgPicture.asset('assets/svgs/enable_edit.svg'),
        ),
        horizontalSpace(16),
      ],
    );
  }
}
