import 'package:evetick/features/event_booking/ui/widgets/select_chair_widgets/seat_widget.dart';

class SelectChairState {
  const SelectChairState({
    required this.rowLabels,
    required this.leftSeats,
    required this.rightSeats,
    required this.seatPrice,
  });

  factory SelectChairState.initial() {
    return SelectChairState(
      rowLabels: const ['A', 'B', 'C', 'D', 'E'],
      seatPrice: 79.0,
      leftSeats: [
        
        List.filled(5, SeatStatus.available),
        List.filled(5, SeatStatus.available),
        List.filled(5, SeatStatus.available),
        List.filled(5, SeatStatus.available),
        List.filled(5, SeatStatus.available),
      ],
      rightSeats: [
        
        List.filled(5, SeatStatus.available),
        List.filled(5, SeatStatus.available),
        List.filled(5, SeatStatus.available),
        List.filled(5, SeatStatus.available),
        List.filled(5, SeatStatus.available),
      ],
    );
  }

  final List<String> rowLabels;
  final List<List<SeatStatus>> leftSeats;
  final List<List<SeatStatus>> rightSeats;
  final double seatPrice;

  List<String> get selectedSeatLabels {
    final labels = <String>[];

    for (var row = 0; row < rowLabels.length; row++) {
      final leftRow = leftSeats[row];
      final rightRow = rightSeats[row];

      for (var i = 0; i < leftRow.length; i++) {
        if (leftRow[i] == SeatStatus.selected) {
          labels.add('${rowLabels[row]}${i + 1}');
        }
      }
      for (var i = 0; i < rightRow.length; i++) {
        if (rightRow[i] == SeatStatus.selected) {
          labels.add('${rowLabels[row]}${leftRow.length + i + 1}');
        }
      }
    }

    return labels;
  }

  double get totalPrice => selectedSeatLabels.length * seatPrice;

  SelectChairState copyWith({
    List<String>? rowLabels,
    List<List<SeatStatus>>? leftSeats,
    List<List<SeatStatus>>? rightSeats,
    double? seatPrice,
  }) {
    return SelectChairState(
      rowLabels: rowLabels ?? this.rowLabels,
      leftSeats: leftSeats ?? this.leftSeats,
      rightSeats: rightSeats ?? this.rightSeats,
      seatPrice: seatPrice ?? this.seatPrice,
    );
  }
}
