
import 'package:evetick/features/event_booking/ui/widgets/select_chair_widgets/seat_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SeatGroup extends StatelessWidget {
  const SeatGroup({required this.seats, required this.onTap});

  final List<SeatStatus> seats;
  final void Function(int index) onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(seats.length, (index) {
        return Padding(
          padding: EdgeInsets.only(right: index == seats.length - 1 ? 0 : 4.w),
          child: SeatWidget(
            status: seats[index],
            onTap: () => onTap(index),
          ),
        );
      }),
    );
  }
}