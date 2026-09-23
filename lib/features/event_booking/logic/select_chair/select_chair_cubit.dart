import 'package:evetick/features/event_booking/logic/select_chair/select_chair_state.dart';
import 'package:evetick/features/event_booking/ui/widgets/select_chair_widgets/seat_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectChairCubit extends Cubit<SelectChairState> {
  SelectChairCubit() : super(SelectChairState.initial());

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

    targetRow[seatIndex] = current == SeatStatus.selected
        ? SeatStatus.available
        : SeatStatus.selected;

    emit(state.copyWith(leftSeats: leftSeats, rightSeats: rightSeats));
  }

  void reset() => emit(SelectChairState.initial());

  List<List<SeatStatus>> _cloneSeats(List<List<SeatStatus>> seats) {
    return seats.map((row) => List<SeatStatus>.of(row)).toList();
  }
}
