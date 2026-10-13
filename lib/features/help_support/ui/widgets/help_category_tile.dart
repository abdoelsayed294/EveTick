import 'package:evetick/core/helpers/extentions.dart';
import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/routing/routes.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/features/help_support/data/models/help_category.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HelpCategoryTile extends StatelessWidget {
  final HelpCategory category;

  const HelpCategoryTile({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.lightBlue,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: () =>
            context.pushNamed(Routes.sendUsScreen, arguments: category),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56.w,
              height: 56.h,
              decoration: const BoxDecoration(
                color: ColorsManager.hotBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(
                category.icon,
                color: ColorsManager.orange,
                size: 26.sp,
              ),
            ),
            verticalSpace(12),
            Text(
              category.label(AppLocalizations.of(context)!),
              style: TextStyles.font16WhiteMid(context),
            ),
          ],
        ),
      ),
    );
  }
}
