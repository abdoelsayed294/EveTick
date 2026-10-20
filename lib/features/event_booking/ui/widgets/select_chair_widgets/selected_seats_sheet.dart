import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/features/event_booking/ui/widgets/select_chair_widgets/seat_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectedSeatsSheet extends StatelessWidget {
  const SelectedSeatsSheet({super.key, required this.selectedSeatLabels});

  final List<String> selectedSeatLabels;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.colors.lightBlue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selected Seats (${selectedSeatLabels.length})',
            style: TextStyles.font16WhiteBold(context),
          ),
          verticalSpace(16),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: selectedSeatLabels
                .map((label) => SeatChip(label: label))
                .toList(),
          ),
          verticalSpace(16),
        ],
      ),
    );
  }
}
