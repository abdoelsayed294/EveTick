/// "just now", "5 minutes ago", "2 days ago", "3 weeks ago", "1 year ago"
String formatTimeAgo(DateTime? date, {DateTime? now}) {
  if (date == null) return 'just now';
  final diff = (now ?? DateTime.now()).difference(date);

  if (diff.inSeconds < 60) return 'just now';
  if (diff.inMinutes < 60) return _unit(diff.inMinutes, 'minute');
  if (diff.inHours < 24) return _unit(diff.inHours, 'hour');
  if (diff.inDays < 7) return _unit(diff.inDays, 'day');
  if (diff.inDays < 30) return _unit(diff.inDays ~/ 7, 'week');
  if (diff.inDays < 365) return _unit(diff.inDays ~/ 30, 'month');
  return _unit(diff.inDays ~/ 365, 'year');
}

String _unit(int value, String name) =>
    '$value $name${value == 1 ? '' : 's'} ago';
