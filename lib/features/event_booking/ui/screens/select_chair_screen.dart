import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/features/event_booking/ui/widgets/select_chair_widgets/seat_legend.dart';
import 'package:evetick/features/event_booking/ui/widgets/select_chair_widgets/seat_map.dart';
import 'package:evetick/features/event_booking/ui/widgets/select_chair_widgets/selected_seats_bloc_builder.dart';
import 'package:evetick/features/event_booking/ui/widgets/select_chair_widgets/stage_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectChairScreen extends StatelessWidget {
  const SelectChairScreen({super.key, this.onNext});

  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 24.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(child: StageIndicator()),
                    verticalSpace(56),
                    const SeatMap(),
                    verticalSpace(16),
                    const SeatLegend(),
                  ],
                ),
              ),
            ),
          ),
          SelectedSeatsBarBuilder(onNext: onNext),
        ],
      ),
    );
  }
}