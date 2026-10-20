import 'package:evetick/l10n/app_localizations.dart';

String notificationTimeLabel(
  AppLocalizations l10n,
  DateTime? date, {
  DateTime? now,
}) {
  if (date == null) return l10n.notificationsTimeAgoJustNow('1');

  final diff = (now ?? DateTime.now()).difference(date);

  if (diff.inMinutes < 60) {
    final minutes = diff.inMinutes < 1 ? 1 : diff.inMinutes;
    return l10n.notificationsTimeAgoJustNow('$minutes');
  }
  if (diff.inHours < 24) {
    return l10n.notificationsTimeAgoHoursAgo('${diff.inHours}');
  }
  if (diff.inDays < 2) return l10n.notificationsTimeAgoYesterday;
  return l10n.notificationsTimeAgoDaysAgo('${diff.inDays}');
}
