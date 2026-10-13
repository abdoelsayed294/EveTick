import 'package:evetick/core/helpers/date_formatter.dart';
import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shown in the profile instead of the buttons once the terms are accepted.
class TermsAcceptedBanner extends StatelessWidget {
  final DateTime? acceptedAt;

  const TermsAcceptedBanner({super.key, this.acceptedAt});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final text = acceptedAt == null
        ? l10n.termsAccepted
        : l10n.termsAcceptedOn(formatDate(acceptedAt!));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check_circle, color: ColorsManager.confirmed, size: 20.sp),
        horizontalSpace(8),
        Text(text, style: TextStyles.font14LightGrayRegular(context)),
      ],
    );
  }
}
