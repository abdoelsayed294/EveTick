/// Maps `events/{id}.seatingConfig` from Firestore.
///
/// seatingConfig: {
///   layoutType: "seating",
///   rows: 4,
///   seatsPerRow: 15,
///   sections: [],
///   seatMap: [ { row: 0, seats: ["available", "available", ...] }, ... ]
/// }
///
/// Seat statuses are kept as raw strings here so the data layer stays
/// independent from the UI (the cubit maps them to `SeatStatus`).
class SeatingConfig {
  final String layoutType;
  final int rows;
  final int seatsPerRow;
  final List<List<String>> seatMap;

  const SeatingConfig({
    required this.layoutType,
    required this.rows,
    required this.seatsPerRow,
    required this.seatMap,
  });

  factory SeatingConfig.fromJson(Map<String, dynamic> json) {
    final rawRows = (json['seatMap'] as List<dynamic>? ?? [])
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();


    final seatMap = rawRows
        .map((r) => (r['seats'] as List<dynamic>? ?? [])
            .map((s) => s.toString())
            .toList())
        .toList();

    return SeatingConfig(
      layoutType: json['layoutType'] as String? ?? 'seating',
      rows: (json['rows'] as num?)?.toInt() ?? seatMap.length,
      seatsPerRow: (json['seatsPerRow'] as num?)?.toInt() ??
          (seatMap.isEmpty ? 0 : seatMap.first.length),
      seatMap: seatMap,
    );
  }
}
