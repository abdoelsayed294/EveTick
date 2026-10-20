import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/features/notifications/ui/widgets/notification_filter_chips.dart';
import 'package:evetick/features/notifications/ui/widgets/notifications_bloc_builder.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Notifications: All / Events / Tickets chips, the recent ones, then the
/// "EARLIER" section.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: context.colors.white),
        title: Text(
          l10n.notificationsTitle,
          style: TextStyles.font18WhiteBold(context),
        ),
      ),
      body: Column(
        children: [
          verticalSpace(8),
          const NotificationFilterChips(),
          verticalSpace(16),
          const Expanded(child: NotificationsBlocBuilder()),
        ],
      ),
    );
  }
}
