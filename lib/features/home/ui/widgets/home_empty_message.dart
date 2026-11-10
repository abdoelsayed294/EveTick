import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeEmptyMessage extends StatelessWidget {
  const HomeEmptyMessage({super.key, required this.hasEvents});

  final bool hasEvents;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(bottom: 120.h),
          child: Text(
            hasEvents ? l10n.homeNoSearchResults : l10n.homeNoEventsYet,
            style: TextStyles.font16LightGrayRegular(context),
          ),
        ),
      ),
    );
  }
}
