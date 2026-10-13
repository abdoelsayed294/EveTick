/// Read model of `orders/{orderId}` used by the ticket screen.
class TicketModel {
  const TicketModel({
    required this.orderId,
    required this.eventTitle,
    required this.eventStartAt,
    required this.status,
    required this.seats,
    required this.sectionLines,
    this.eventCategory,
    this.eventEndAt,
    this.eventLocation,
    this.attendeeName,
  });

  final String orderId;
  final String eventTitle;
  final String eventStartAt;
  final String status;
  final List<String> seats; // labels: A1, A2...
  final List<String> sectionLines; // "VIP Zone × 2" (events without seats)
  final String? eventCategory;
  final String? eventEndAt;
  final String? eventLocation;
  final String? attendeeName;

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      orderId: json['orderId'] as String,
      eventTitle: json['eventTitle'] as String? ?? '',
      eventStartAt: json['eventStartAt'] as String? ?? '',
      status: json['status'] as String? ?? 'confirmed',
      seats: (json['seats'] as List<dynamic>? ?? [])
          .map((s) => (s as Map)['label'].toString())
          .toList(),
      sectionLines: (json['tickets'] as List<dynamic>? ?? [])
          .map((t) => Map<String, dynamic>.from(t as Map))
          .map((t) =>
              '${t['sectionName'] ?? t['ticketName'] ?? ''} × ${t['quantity'] ?? 1}')
          .toList(),
      eventCategory: json['eventCategory'] as String?,
      eventEndAt: json['eventEndAt'] as String?,
      eventLocation: json['eventLocation'] as String?,
      attendeeName: json['attendeeName'] as String?,
    );
  }

  bool get hasSeats => seats.isNotEmpty;

  /// "Seat" for seated events, "Section" otherwise.
  String get accessLabel => hasSeats ? 'Seat' : 'Section';

  String get accessText => hasSeats ? seatsText : sectionLines.join('  •  ');

  String get statusText =>
      status.isEmpty ? '' : status[0].toUpperCase() + status.substring(1);

  /// ["A1","A2","B5"] -> "Row A: 1, 2  •  Row B, 5"
  String get seatsText {
    final byRow = <String, List<String>>{};
    for (final label in seats) {
      final match = RegExp(r'^([A-Z]+)(\d+)$').firstMatch(label);
      if (match == null) {
        byRow.putIfAbsent('', () => []).add(label);
      } else {
        byRow.putIfAbsent(match.group(1)!, () => []).add(match.group(2)!);
      }
    }
    return byRow.entries.map((e) {
      if (e.key.isEmpty) return e.value.join(', ');
      if (e.value.length == 1) return 'Row ${e.key}, ${e.value.first}';
      return 'Row ${e.key}: ${e.value.join(', ')}';
    }).join('  •  ');
  }
}
