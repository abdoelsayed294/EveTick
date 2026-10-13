/// Finds which venue section a ticket type belongs to.
///
/// Tried in this order:
///  1. same name ("VIP Zone" == "vip zone")
///  2. one name contains the other, when only one section matches
///     ("VIP" <-> "VIP Zone")
///  3. same position (3rd ticket type <-> 3rd section), when both lists
///     have the same length
/// Returns null if nothing matches.
///
/// TODO: let the organizer app write a `sectionName` on each ticket tier and
/// use it here first, so this guessing is not needed.
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
