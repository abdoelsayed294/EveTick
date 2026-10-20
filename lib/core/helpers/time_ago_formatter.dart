/// "just now", "5 minutes ago", "2 days ago", "3 weeks ago", "1 year ago"
import 'dart:ui';

String formatTimeAgo(DateTime? date, {DateTime? now, Locale? locale}) {
  final isArabic = locale?.languageCode == 'ar';
  if (date == null) return isArabic ? 'الآن' : 'just now';
  final diff = (now ?? DateTime.now()).difference(date);

  if (diff.inSeconds < 60) return isArabic ? 'الآن' : 'just now';
  if (diff.inMinutes < 60) return _unit(diff.inMinutes, 'minute', isArabic);
  if (diff.inHours < 24) return _unit(diff.inHours, 'hour', isArabic);
  if (diff.inDays < 7) return _unit(diff.inDays, 'day', isArabic);
  if (diff.inDays < 30) return _unit(diff.inDays ~/ 7, 'week', isArabic);
  if (diff.inDays < 365) return _unit(diff.inDays ~/ 30, 'month', isArabic);
  return _unit(diff.inDays ~/ 365, 'year', isArabic);
}

String _unit(int value, String name, bool isArabic) {
  if (!isArabic) return '$value $name${value == 1 ? '' : 's'} ago';

  const labels = {
    'minute': 'دقيقة',
    'hour': 'ساعة',
    'day': 'يوم',
    'week': 'أسبوع',
    'month': 'شهر',
    'year': 'سنة',
  };
  return 'منذ $value ${labels[name]}';
}
