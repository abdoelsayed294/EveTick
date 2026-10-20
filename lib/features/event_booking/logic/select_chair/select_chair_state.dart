import 'package:evetick/features/event_booking/logic/select_chair/seat_status.dart';
import 'package:evetick/features/event_booking/logic/select_chair/selected_seat.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'select_chair_state.freezed.dart';

@freezed
class SelectChairState with _$SelectChairState {
  const SelectChairState._();

  const factory SelectChairState.initial() = _Initial;
  const factory SelectChairState.loading() = Loading;
  const factory SelectChairState.success({
    required bool isSeated,
    required List<String> sectionNames,
    required List<String> rowLabels,
    required List<List<SeatStatus>> leftSeats,
    required List<List<SeatStatus>> rightSeats,

    required int maxSeats,

    required double totalPrice,
    required List<SelectedSeat> selectedSeats,
    required bool isSelectionComplete,
  }) = Success;
  const factory SelectChairState.error({required String error}) = Error;

  bool get isSeatedFlow =>
      maybeMap(success: (s) => s.isSeated, orElse: () => true);
}
