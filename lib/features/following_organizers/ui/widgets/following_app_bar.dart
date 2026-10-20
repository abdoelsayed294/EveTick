import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FollowingAppBar extends StatelessWidget {
  const FollowingAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.of(context).maybePop(),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20.sp,
                color: context.colors.white,
              ),
            ),
          ),
          Text(
            AppLocalizations.of(context)!.followingOrganizersTitle,
            style: TextStyles.font18WhiteBold(context),
          ),
        ],
      ),
    );
  }
}
