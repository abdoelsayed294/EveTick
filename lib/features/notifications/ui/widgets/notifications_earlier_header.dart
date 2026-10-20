import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationsEarlierHeader extends StatelessWidget {
  const NotificationsEarlierHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.only(top: 8.h, bottom: 16.h),
      child: Text(
        l10n.notificationsTimeAgoEarlier,
        style: TextStyle(
          fontSize: 16.sp,
          letterSpacing: 0.5,
          color: context.colors.lightGray,
        ),
      ),
    );
  }
}
