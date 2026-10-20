String? resolveSectionName({
  required String ticketName,
  required int tierIndex,
  required int tiersCount,
  required List<String> sectionNames,
}) {
  if (sectionNames.isEmpty) return null;
  final ticket = _normalize(ticketName);

  final exact = sectionNames.where((s) => _normalize(s) == ticket).toList();
  if (exact.length == 1) return exact.first;

  final partial = sectionNames.where((s) {
    final name = _normalize(s);
    return name.isNotEmpty &&
        ticket.isNotEmpty &&
        (name.contains(ticket) || ticket.contains(name));
  }).toList();
  if (partial.length == 1) return partial.first;

  if (sectionNames.length == tiersCount && tierIndex < sectionNames.length) {
    return sectionNames[tierIndex];
  }
  return null;
}

String _normalize(String value) => value.trim().toLowerCase();
