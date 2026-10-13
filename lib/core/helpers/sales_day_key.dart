/// Daily sales counters live in `events/{id}.salesByDay` as
/// { "d20261013": 5, "d20261014": 2, ... } (UTC days).
/// The booking transaction writes them, the home screen reads them.
String salesDayKey(DateTime date) {
  final utc = date.toUtc();
  final month = utc.month.toString().padLeft(2, '0');
  final day = utc.day.toString().padLeft(2, '0');
  return 'd${utc.year.toString().padLeft(4, '0')}$month$day';
}

DateTime? parseSalesDayKey(String key) {
  final match = RegExp(r'^d(\d{4})(\d{2})(\d{2})$').firstMatch(key);
  if (match == null) return null;
  return DateTime.utc(
    int.parse(match.group(1)!),
    int.parse(match.group(2)!),
    int.parse(match.group(3)!),
  );
}
