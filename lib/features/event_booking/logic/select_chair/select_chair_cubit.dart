import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/event_booking/data/models/seating_config_model.dart';
import 'package:evetick/features/event_booking/data/repo/event_booking_repo.dart';
import 'package:evetick/features/event_booking/logic/select_chair/select_chair_state.dart';
import 'package:evetick/features/event_booking/ui/widgets/select_chair_widgets/seat_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectChairCubit extends Cubit<SelectChairState> {
  final EventBookingRepo eventBookingRepo;

  SelectChairCubit(this.eventBookingRepo) : super(const SelectChairState());

  Future<void> getSeatingConfig(String eventId) async {
    emit(const SelectChairState());

    final result = await eventBookingRepo.getSeatingConfig(eventId);
    result.when(
      success: (config) => emit(_buildState(config)),
      failure: (error) => emit(
        SelectChairState(
          status: SelectChairStatus.error,
          errorMessage: error.message,
        ),
      ),
    );
  }

  
  void setTicketSelection({required int count, required double totalPrice}) {
    final countChanged = count != state.maxSeats;
    emit(
      state.copyWith(
        maxSeats: count,
        totalPrice: totalPrice,
        leftSeats: countChanged ? _clearSelected(state.leftSeats) : null,
        rightSeats: countChanged ? _clearSelected(state.rightSeats) : null,
      ),
    );
  }

  void toggleSeat({
    required int rowIndex,
    required bool isLeft,
    required int seatIndex,
  }) {
    final leftSeats = _cloneSeats(state.leftSeats);
    final rightSeats = _cloneSeats(state.rightSeats);

    final targetRow = isLeft ? leftSeats[rowIndex] : rightSeats[rowIndex];
    final current = targetRow[seatIndex];

    if (current == SeatStatus.reserved) return;

    final isSelecting = current != SeatStatus.selected;
    if (isSelecting && state.selectedSeatLabels.length >= state.maxSeats) return;

    targetRow[seatIndex] =
        isSelecting ? SeatStatus.selected : SeatStatus.available;

    emit(state.copyWith(leftSeats: leftSeats, rightSeats: rightSeats));
  }


  SelectChairState _buildState(SeatingConfig config) {
    final leftSeats = <List<SeatStatus>>[];
    final rightSeats = <List<SeatStatus>>[];

    for (final row in config.seatMap) {
      final statuses = row.map(_parseStatus).toList();
      final leftCount = (statuses.length / 2).ceil(); 
      leftSeats.add(statuses.sublist(0, leftCount));
      rightSeats.add(statuses.sublist(leftCount));
    }

    return SelectChairState(
      status: SelectChairStatus.success,
      layoutType: config.layoutType,
      sectionNames: config.sectionNames,
      rowLabels: List.generate(config.seatMap.length, _rowLabel),
      leftSeats: leftSeats,
      rightSeats: rightSeats,
    );
  }

  /// "available" -> available, anything else (reserved / booked / sold ...)
  /// is treated as not selectable.
  SeatStatus _parseStatus(String value) {
    return value == 'available' ? SeatStatus.available : SeatStatus.reserved;
  }

  /// 0 -> A, 1 -> B, ... 25 -> Z, 26 -> AA
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
