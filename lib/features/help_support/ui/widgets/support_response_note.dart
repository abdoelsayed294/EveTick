import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SupportResponseNote extends StatelessWidget {
  const SupportResponseNote({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final style = TextStyles.font14LightGrayRegular(context);
    final link = l10n.helpSupportFaqSectionLink;
    final parts = l10n.helpSupportResponseTimeNotice.split(link);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: context.colors.textBackground,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info, color: ColorsManager.orange, size: 24.sp),
          horizontalSpace(8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: style,
                children: [
                  for (var i = 0; i < parts.length; i++) ...[
                    TextSpan(text: parts[i]),
                    if (i < parts.length - 1)
                      TextSpan(
                        text: link,
                        style: style.copyWith(color: ColorsManager.orange),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
