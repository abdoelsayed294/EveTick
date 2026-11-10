import 'package:intl/intl.dart';

String formatEventDate(String iso) {
  final date = DateTime.tryParse(iso);
  return date == null ? iso : formatDate(date);
}

String formatEventTime(String iso) {
  final date = DateTime.tryParse(iso);
  return date == null ? '' : DateFormat('hh:mm a').format(date);
}

String formatDate(DateTime date) => DateFormat('MMM d, yyyy').format(date);

String formatTimeRange(String startIso, String? endIso) {
  final start = DateTime.tryParse(startIso);
  if (start == null) return '';
  final format = DateFormat('HH:mm');
  final end = endIso == null ? null : DateTime.tryParse(endIso);
  return end == null
      ? format.format(start)
      : '${format.format(start)} - ${format.format(end)}';
}

String formatShortDateTime(String iso) {
  final date = DateTime.tryParse(iso);
  if (date == null) return iso;
  return '${DateFormat('MMM d').format(date)}  •  ${DateFormat('hh:mm a').format(date)}';
}


String formatDayAndDate(String iso) {
  final date = DateTime.tryParse(iso);
  return date == null ? iso : DateFormat('EEEE, MMM d').format(date);
}

String formatTimeRange12(String startIso, String? endIso) {
  final start = DateTime.tryParse(startIso);
  if (start == null) return '';
  final format = DateFormat('h:mm a');
  final end = endIso == null ? null : DateTime.tryParse(endIso);
  return end == null
      ? format.format(start)
      : '${format.format(start)} - ${format.format(end)}';
}
