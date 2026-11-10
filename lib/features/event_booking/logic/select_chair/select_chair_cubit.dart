import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/event_booking/data/models/seating_config_model.dart';
import 'package:evetick/features/event_booking/data/repo/event_booking_repo.dart';
import 'package:evetick/features/event_booking/logic/select_chair/seat_status.dart';
import 'package:evetick/features/event_booking/logic/select_chair/select_chair_state.dart';
import 'package:evetick/features/event_booking/logic/select_chair/selected_seat.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectChairCubit extends Cubit<SelectChairState> {
  final EventBookingRepo eventBookingRepo;

  SelectChairCubit(this.eventBookingRepo)
      : super(const SelectChairState.initial());

  Future<void> getSeatingConfig(String eventId) async {
    emit(const SelectChairState.loading());

    final result = await eventBookingRepo.getSeatingConfig(eventId);
    result.when(
      success: (config) => _emitFromConfig(config),
      failure: (failure) =>
          emit(SelectChairState.error(error: failure.message)),
    );
  }

  void setTicketSelection({required int count, required double totalPrice}) {
    final current = state.mapOrNull(success: (s) => s);
    if (current == null) return;

    final countChanged = count != current.maxSeats;
    _emitSuccess(
      isSeated: current.isSeated,
      sectionNames: current.sectionNames,
      rowLabels: current.rowLabels,
      leftSeats:
          countChanged ? _clearSelected(current.leftSeats) : current.leftSeats,
      rightSeats: countChanged
          ? _clearSelected(current.rightSeats)
          : current.rightSeats,
      maxSeats: count,
      totalPrice: totalPrice,
    );
  }

  void toggleSeat({
    required int rowIndex,
    required bool isLeft,
    required int seatIndex,
  }) {
    final current = state.mapOrNull(success: (s) => s);
    if (current == null) return;

    final leftSeats = _cloneSeats(current.leftSeats);
    final rightSeats = _cloneSeats(current.rightSeats);

    final targetRow = isLeft ? leftSeats[rowIndex] : rightSeats[rowIndex];
    final seat = targetRow[seatIndex];

    if (seat == SeatStatus.reserved) return;

    final isSelecting = seat != SeatStatus.selected;
    if (isSelecting && current.selectedSeats.length >= current.maxSeats) {
      return;
    }

    targetRow[seatIndex] =
        isSelecting ? SeatStatus.selected : SeatStatus.available;

    _emitSuccess(
      isSeated: current.isSeated,
      sectionNames: current.sectionNames,
      rowLabels: current.rowLabels,
      leftSeats: leftSeats,
      rightSeats: rightSeats,
      maxSeats: current.maxSeats,
      totalPrice: current.totalPrice,
    );
  }

  void _emitFromConfig(SeatingConfig config) {
    final leftSeats = <List<SeatStatus>>[];
    final rightSeats = <List<SeatStatus>>[];

    for (final row in config.seatMap) {
      final statuses = row.map(_parseStatus).toList();
      final leftCount = (statuses.length / 2).ceil();
      leftSeats.add(statuses.sublist(0, leftCount));
      rightSeats.add(statuses.sublist(leftCount));
    }

    _emitSuccess(
      isSeated: config.layoutType == 'seating',
      sectionNames: config.sectionNames,
      rowLabels: List.generate(config.seatMap.length, _rowLabel),
      leftSeats: leftSeats,
      rightSeats: rightSeats,
      maxSeats: 0,
      totalPrice: 0,
    );
  }

  void _emitSuccess({
    required bool isSeated,
    required List<String> sectionNames,
    required List<String> rowLabels,
    required List<List<SeatStatus>> leftSeats,
    required List<List<SeatStatus>> rightSeats,
    required int maxSeats,
    required double totalPrice,
  }) {
    final selected = _selectedSeats(rowLabels, leftSeats, rightSeats);

    emit(
      SelectChairState.success(
        isSeated: isSeated,
        sectionNames: sectionNames,
        rowLabels: rowLabels,
        leftSeats: leftSeats,
        rightSeats: rightSeats,
        maxSeats: maxSeats,
        totalPrice: totalPrice,
        selectedSeats: selected,
        isSelectionComplete: maxSeats > 0 && selected.length == maxSeats,
      ),
    );
  }

  List<SelectedSeat> _selectedSeats(
    List<String> rowLabels,
    List<List<SeatStatus>> leftSeats,
    List<List<SeatStatus>> rightSeats,
  ) {
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

  SeatStatus _parseStatus(String value) {
    return value == 'available' ? SeatStatus.available : SeatStatus.reserved;
  }

  String _rowLabel(int index) {
    const letters = 26;
    final last = String.fromCharCode(65 + index % letters);
    if (index < letters) return last;
    return '${String.fromCharCode(65 + index ~/ letters - 1)}$last';
  }

  List<List<SeatStatus>> _clearSelected(List<List<SeatStatus>> seats) {
    return seats
        .map((row) => row
            .map((s) => s == SeatStatus.selected ? SeatStatus.available : s)
            .toList())
        .toList();
  }

  List<List<SeatStatus>> _cloneSeats(List<List<SeatStatus>> seats) {
    return seats.map((row) => List<SeatStatus>.of(row)).toList();
  }
}
