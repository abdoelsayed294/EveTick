/// Where a ticket is in time, decided from the event dates.
enum TicketPhase { upcoming, active, past }

/// Light read model of `orders/{orderId}` for the My Tickets list.
class MyTicket {
  const MyTicket({
    required this.orderId,
    required this.eventTitle,
    required this.coverImageUrl,
    required this.startAt,
    required this.endAt,
    required this.status,
    this.location,
  });

  final String orderId;
  final String eventTitle;
  final String coverImageUrl;
  final String startAt;
  final String endAt;
  final String status;
  final String? location;

  factory MyTicket.fromJson(Map<String, dynamic> json) {
    return MyTicket(
      orderId: json['orderId'] as String,
      eventTitle: json['eventTitle'] as String? ?? '',
      coverImageUrl: json['eventCoverImageUrl'] as String? ?? '',
      startAt: json['eventStartAt'] as String? ?? '',
      endAt: json['eventEndAt'] as String? ?? '',
      status: json['status'] as String? ?? 'confirmed',
      location: json['eventLocation'] as String?,
    );
  }

  DateTime? get startDate => DateTime.tryParse(startAt);
  DateTime? get endDate => DateTime.tryParse(endAt);

  /// Past once the event ended (or started, when there is no end date).
  TicketPhase phase(DateTime now) {
    final start = startDate;
    final end = endDate ?? start;
    if (end != null && end.isBefore(now)) return TicketPhase.past;
    if (start != null && !start.isAfter(now)) return TicketPhase.active;
    return TicketPhase.upcoming;
  }

  /// "CONFIRMED" / "ACTIVE" / "COMPLETED" (or the order status if it is
  /// not confirmed, e.g. "CANCELLED").
  String statusLabel(DateTime now) {
    if (status != 'confirmed') return status.toUpperCase();
    switch (phase(now)) {
      case TicketPhase.past:
        return 'COMPLETED';
      case TicketPhase.active:
        return 'ACTIVE';
      case TicketPhase.upcoming:
        return 'CONFIRMED';
    }
  }
}
