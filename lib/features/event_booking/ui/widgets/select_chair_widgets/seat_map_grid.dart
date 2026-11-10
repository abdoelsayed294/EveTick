import 'package:evetick/features/event_booking/logic/select_chair/seat_status.dart';
import 'package:evetick/features/event_booking/ui/widgets/select_chair_widgets/seat_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SeatMapGrid extends StatelessWidget {
  const SeatMapGrid({
    super.key,
    required this.rowLabels,
    required this.leftSeats,
    required this.rightSeats,
    required this.onSeatTap,
  });

  final List<String> rowLabels;
  final List<List<SeatStatus>> leftSeats;
  final List<List<SeatStatus>> rightSeats;
  final void Function(int rowIndex, bool isLeft, int seatIndex) onSeatTap;

  static const double viewportHeight = 260;
  static const double _aisleWidth = 48;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: viewportHeight.h,
      width: double.infinity,
      child: InteractiveViewer(
        constrained: false,
        minScale: 0.6,
        maxScale: 2.5,
        boundaryMargin: EdgeInsets.symmetric(horizontal: 80.w, vertical: 40.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(rowLabels.length, (rowIndex) {
            final bool isLast = rowIndex == rowLabels.length - 1;

            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 26.h),
              child: SeatRow(
                label: rowLabels[rowIndex],
                leftSeats: leftSeats[rowIndex],
                rightSeats: rightSeats[rowIndex],
                aisleWidth: _aisleWidth,
                onSeatTap: (isLeft, seatIndex) =>
                    onSeatTap(rowIndex, isLeft, seatIndex),
              ),
            );
          }),
        ),
      ),
    );
  }
}
