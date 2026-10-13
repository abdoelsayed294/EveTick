import 'package:evetick/core/helpers/extentions.dart';
import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/routing/routes.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/core/widgets/filled_app_text_button.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HelpContactCard extends StatelessWidget {
  const HelpContactCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: context.colors.lightBlue,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Text(
            l10n.helpSupportStillNeedHelp,
            style: TextStyles.font16WhiteMid(context),
          ),
          verticalSpace(12),
          Text(
            l10n.helpSupportSupportAvailabilityNotice,
            textAlign: TextAlign.center,
            style: TextStyles.font16LightGrayRegular(context),
          ),
          verticalSpace(16),
          FilledAppTextButton(
            buttonText: l10n.helpSupportContactSupport,
            onPressed: () => context.pushNamed(Routes.sendUsScreen),
          ),
        ],
      ),
    );
  }
}
