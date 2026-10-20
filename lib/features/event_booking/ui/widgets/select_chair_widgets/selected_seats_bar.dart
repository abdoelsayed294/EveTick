import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/core/widgets/filled_app_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evetick/features/event_booking/ui/widgets/select_chair_widgets/seat_chip.dart';
import 'package:evetick/features/event_booking/ui/widgets/select_chair_widgets/selected_seats_sheet.dart';

class SelectedSeatsBar extends StatelessWidget {
  const SelectedSeatsBar({
    super.key,
    required this.selectedSeatLabels,
    required this.maxSeats,
    required this.totalPrice,
    required this.onProceed,
    this.maxVisibleSeats = 3,
  });

  final List<String> selectedSeatLabels;
  final int maxSeats;
  final double totalPrice;
  final VoidCallback onProceed;
  final int maxVisibleSeats;

  void _showAllSelectedSeats(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.colors.hotBackground,
      builder: (_) =>
          SelectedSeatsSheet(selectedSeatLabels: selectedSeatLabels),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleSeats = selectedSeatLabels.take(maxVisibleSeats).toList();
    final int remaining = selectedSeatLabels.length - visibleSeats.length;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 16.h,
        bottom: 32.h,
      ),
      decoration: BoxDecoration(
        color: context.colors.lightBlue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected Seats (${selectedSeatLabels.length}/$maxSeats)',
                      style: TextStyles.font12LightGrayRegular(context),
                    ),
                    verticalSpace(8),
                    selectedSeatLabels.isEmpty
                        ? Text(
                            'None',
                            style: TextStyles.font16WhiteRegular(context),
                          )
                        : Row(
                            children: [
                              ...visibleSeats.map(
                                (label) => Padding(
                                  padding: EdgeInsets.only(right: 8.w),
                                  child: SeatChip(label: label),
                                ),
                              ),
                              if (remaining > 0)
                                GestureDetector(
                                  onTap: () => _showAllSelectedSeats(context),
                                  child: SeatChip(label: '+$remaining'),
                                ),
                            ],
                          ),
                  ],
                ),
              ),
              horizontalSpace(12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Total Price',
                    style: TextStyles.font12LightGrayRegular(context),
                  ),
                  verticalSpace(8),
                  Text(
                    '\$${totalPrice.toStringAsFixed(2)}',
                    style: TextStyles.font18WhiteBold(context),
                  ),
                ],
              ),
            ],
          ),
          verticalSpace(24),
          FilledAppTextButton(
            buttonText: 'Proceed to Payment',
            onPressed: onProceed,
          ),
        ],
      ),
    );
  }
}
