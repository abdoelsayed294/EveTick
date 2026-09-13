import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/core/widgets/filled_app_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectedSeatsBar extends StatelessWidget {
  const SelectedSeatsBar({
    super.key,
    required this.selectedSeatLabels,
    required this.totalPrice,
    required this.onProceed,
    this.maxVisibleSeats = 3,
  });

  final List<String> selectedSeatLabels;
  final double totalPrice;
  final VoidCallback onProceed;
  final int maxVisibleSeats;

  void _showAllSelectedSeats(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.colors.hotBackground,
      builder: (sheetContext) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: sheetContext.colors.lightBlue,
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
                style: TextStyles.font16WhiteBold(sheetContext),
              ),
              verticalSpace(16),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: selectedSeatLabels
                    .map((label) => _SeatChip(label: label))
                    .toList(),
              ),
              verticalSpace(16),
            ],
          ),
        );
      },
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
                      'Selected Seats',
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
                                  child: _SeatChip(label: label),
                                ),
                              ),
                              if (remaining > 0)
                                GestureDetector(
                                  onTap: () => _showAllSelectedSeats(context),
                                  child: _SeatChip(label: '+$remaining'),
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

class _SeatChip extends StatelessWidget {
  const _SeatChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44.w,
      height: 31.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: ColorsManager.hotBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorsManager.orange, width: 0.5),
      ),
      child: Text(label, style: TextStyles.font16OrangeBold),
    );
  }
}
