import 'package:evetick/features/event_booking/logic/select_chair/select_chair_cubit.dart';
import 'package:evetick/features/event_booking/logic/select_chair/select_chair_state.dart';
import 'package:evetick/features/event_booking/ui/widgets/select_chair_widgets/seat_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SeatMap extends StatelessWidget {
  const SeatMap({super.key});

  static const double _viewportHeight = 260;
  static const double _aisleWidth = 48;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectChairCubit, SelectChairState>(
      builder: (context, state) {
        final cubit = context.read<SelectChairCubit>();

        return SizedBox(
          height: _viewportHeight.h,
          width: double.infinity,
          child: InteractiveViewer(
            constrained: false,
            minScale: 0.6,
            maxScale: 2.5,
            boundaryMargin: EdgeInsets.symmetric(
              horizontal: 80.w,
              vertical: 40.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(state.rowLabels.length, (rowIndex) {
                final bool isLast = rowIndex == state.rowLabels.length - 1;

                return Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 26.h),
                  child: SeatRow(
                    label: state.rowLabels[rowIndex],
                    leftSeats: state.leftSeats[rowIndex],
                    rightSeats: state.rightSeats[rowIndex],
                    aisleWidth: _aisleWidth,
                    onSeatTap: (isLeft, seatIndex) => cubit.toggleSeat(
                      rowIndex: rowIndex,
                      isLeft: isLeft,
                      seatIndex: seatIndex,
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
