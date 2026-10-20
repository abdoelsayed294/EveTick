import 'package:evetick/features/event_booking/data/models/seating_section_model.dart';

class SeatingConfig {
  final String layoutType;
  final int rows;
  final int seatsPerRow;
  final List<List<String>> seatMap;
  final List<SeatingSection> sections;

  const SeatingConfig({
    required this.layoutType,
    required this.rows,
    required this.seatsPerRow,
    required this.seatMap,
    this.sections = const [],
  });

  factory SeatingConfig.general() => const SeatingConfig(
        layoutType: 'sections',
        rows: 0,
        seatsPerRow: 0,
        seatMap: [],
      );

  factory SeatingConfig.fromJson(Map<String, dynamic> json) {
    final rawRows = (json['seatMap'] as List<dynamic>? ?? [])
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();

    final seatMap = rawRows
        .map((r) => (r['seats'] as List<dynamic>? ?? [])
            .map((s) => s.toString())
            .toList())
        .toList();

    final sections = (json['sections'] as List<dynamic>? ?? [])
        .map((e) => Map<String, dynamic>.from(e as Map))
        .map((s) => SeatingSection(
              name: (s['sectionName'] as String? ?? '').trim(),
              capacity: (s['capacity'] as num?)?.toInt() ?? 0,
            ))
        .where((s) => s.name.isNotEmpty)
        .toList();

    return SeatingConfig(
      layoutType: json['layoutType'] as String? ??
          (seatMap.isNotEmpty ? 'seating' : 'sections'),
      rows: (json['rows'] as num?)?.toInt() ?? seatMap.length,
      seatsPerRow: (json['seatsPerRow'] as num?)?.toInt() ??
          (seatMap.isEmpty ? 0 : seatMap.first.length),
      seatMap: seatMap,
      sections: sections,
    );
  }

  bool get isSeated => layoutType == 'seating';

  List<String> get sectionNames => sections.map((s) => s.name).toList();
}
