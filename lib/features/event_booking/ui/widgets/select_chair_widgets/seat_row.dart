import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/features/event_booking/ui/widgets/select_chair_widgets/row_label.dart';
import 'package:evetick/features/event_booking/ui/widgets/select_chair_widgets/seat_group.dart';
import 'package:evetick/features/event_booking/ui/widgets/select_chair_widgets/seat_widget.dart';
import 'package:flutter/material.dart';


class SeatRow extends StatelessWidget {
  const SeatRow({
    super.key,
    required this.label,
    required this.leftSeats,
    required this.rightSeats,
    required this.onSeatTap,
    this.aisleWidth = 48,
  });

  final String label;
  final List<SeatStatus> leftSeats;
  final List<SeatStatus> rightSeats;
  final void Function(bool isLeft, int index) onSeatTap;
  final double aisleWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        RowLabel(label),
        horizontalSpace(24),
        SeatGroup(
          seats: leftSeats,
          onTap: (index) => onSeatTap(true, index),
        ),
        horizontalSpace(aisleWidth),
        SeatGroup(
          seats: rightSeats,
          onTap: (index) => onSeatTap(false, index),
        ),
        horizontalSpace(24),
        RowLabel(label),
      ],
    );
  }
}


