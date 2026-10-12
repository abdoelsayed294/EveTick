import 'package:intl/intl.dart';

/// "2026-09-25T03:07:00.000" -> "Sep 25, 2026"
String formatEventDate(String iso) {
  final date = DateTime.tryParse(iso);
  return date == null ? iso : formatDate(date);
}

/// "2026-09-25T03:07:00.000" -> "03:07 AM"
String formatEventTime(String iso) {
  final date = DateTime.tryParse(iso);
  return date == null ? '' : DateFormat('hh:mm a').format(date);
}

/// DateTime -> "Oct 12, 2026"
String formatDate(DateTime date) => DateFormat('MMM d, yyyy').format(date);

/// ("2026-09-25T19:00:00", "2026-09-25T23:00:00") -> "19:00 - 23:00"
String formatTimeRange(String startIso, String? endIso) {
  final start = DateTime.tryParse(startIso);
  if (start == null) return '';
  final format = DateFormat('HH:mm');
  final end = endIso == null ? null : DateTime.tryParse(endIso);
  return end == null
      ? format.format(start)
      : '${format.format(start)} - ${format.format(end)}';
}
