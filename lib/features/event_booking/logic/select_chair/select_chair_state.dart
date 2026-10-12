import 'package:evetick/features/event_booking/ui/widgets/select_chair_widgets/seat_widget.dart';

enum SelectChairStatus { loading, success, error }

/// A picked seat: its position in `seatMap` and its display label (A1, B7...).
class SelectedSeat {
  const SelectedSeat({
    required this.rowIndex,
    required this.seatIndex,
    required this.label,
  });

  final int rowIndex;
  final int seatIndex;
  final String label;
}

class SelectChairState {
  const SelectChairState({
    this.status = SelectChairStatus.loading,
    this.errorMessage,
    this.rowLabels = const [],
    this.leftSeats = const [],
    this.rightSeats = const [],
    this.maxSeats = 0,
    this.totalPrice = 0,
  });

  final SelectChairStatus status;
  final String? errorMessage;
  final List<String> rowLabels;
  final List<List<SeatStatus>> leftSeats;
  final List<List<SeatStatus>> rightSeats;

  /// Number of tickets bought in the previous step = seats the user must pick.
  final int maxSeats;

  /// Price of the tickets chosen in the previous step.
  final double totalPrice;

  List<SelectedSeat> get selectedSeats {
    final seats = <SelectedSeat>[];

    for (var row = 0; row < rowLabels.length; row++) {
      final leftRow = leftSeats[row];
      final rightRow = rightSeats[row];

      for (var i = 0; i < leftRow.length; i++) {
        if (leftRow[i] == SeatStatus.selected) {
          seats.add(SelectedSeat(
            rowIndex: row,
            seatIndex: i,
            label: '${rowLabels[row]}${i + 1}',
          ));
        }
      }
      for (var i = 0; i < rightRow.length; i++) {
        if (rightRow[i] == SeatStatus.selected) {
          final flatIndex = leftRow.length + i;
          seats.add(SelectedSeat(
            rowIndex: row,
            seatIndex: flatIndex,
            label: '${rowLabels[row]}${flatIndex + 1}',
          ));
        }
      }
    }

    return seats;
  }

  List<String> get selectedSeatLabels =>
      selectedSeats.map((s) => s.label).toList();

  bool get isSelectionComplete =>
      maxSeats > 0 && selectedSeatLabels.length == maxSeats;

  SelectChairState copyWith({
    SelectChairStatus? status,
    String? errorMessage,
    List<String>? rowLabels,
    List<List<SeatStatus>>? leftSeats,
    List<List<SeatStatus>>? rightSeats,
    int? maxSeats,
    double? totalPrice,
  }) {
    return SelectChairState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      rowLabels: rowLabels ?? this.rowLabels,
      leftSeats: leftSeats ?? this.leftSeats,
      rightSeats: rightSeats ?? this.rightSeats,
      maxSeats: maxSeats ?? this.maxSeats,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}
