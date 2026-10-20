import 'package:evetick/core/widgets/app_error_view.dart';
import 'package:evetick/features/event_booking/logic/select_chair/select_chair_cubit.dart';
import 'package:evetick/features/event_booking/logic/select_chair/select_chair_state.dart';
import 'package:evetick/features/event_booking/ui/widgets/select_chair_widgets/seat_map_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SeatMapBlocBuilder extends StatelessWidget {
  const SeatMapBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectChairCubit, SelectChairState>(
      builder: (context, state) {
        return state.maybeMap(
          success: (s) => SeatMapGrid(
            rowLabels: s.rowLabels,
            leftSeats: s.leftSeats,
            rightSeats: s.rightSeats,
            onSeatTap: (rowIndex, isLeft, seatIndex) =>
                context.read<SelectChairCubit>().toggleSeat(
                      rowIndex: rowIndex,
                      isLeft: isLeft,
                      seatIndex: seatIndex,
                    ),
          ),
          error: (e) => SizedBox(
            height: SeatMapGrid.viewportHeight.h,
            child: AppErrorView(message: e.error),
          ),
          orElse: () => SizedBox(
            height: SeatMapGrid.viewportHeight.h,
            child: const Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}
