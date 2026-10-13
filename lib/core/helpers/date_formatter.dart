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

/// "2026-10-24T19:00:00" -> "Oct 24  •  07:00 PM"
String formatShortDateTime(String iso) {
  final date = DateTime.tryParse(iso);
  if (date == null) return iso;
  return '${DateFormat('MMM d').format(date)}  •  ${DateFormat('hh:mm a').format(date)}';
}


/// "2026-10-24T19:00:00" -> "Saturday, Oct 24"
String formatDayAndDate(String iso) {
  final date = DateTime.tryParse(iso);
  return date == null ? iso : DateFormat('EEEE, MMM d').format(date);
}

/// ("2026-10-24T19:00:00", "2026-10-24T23:30:00") -> "7:00 PM - 11:30 PM"
String formatTimeRange12(String startIso, String? endIso) {
  final start = DateTime.tryParse(startIso);
  if (start == null) return '';
  final format = DateFormat('h:mm a');
  final end = endIso == null ? null : DateTime.tryParse(endIso);
  return end == null
      ? format.format(start)
      : '${format.format(start)} - ${format.format(end)}';
}
