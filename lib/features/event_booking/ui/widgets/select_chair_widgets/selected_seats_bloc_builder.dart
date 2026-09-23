import 'package:evetick/features/event_booking/logic/select_chair/select_chair_cubit.dart';
import 'package:evetick/features/event_booking/logic/select_chair/select_chair_state.dart';
import 'package:evetick/features/event_booking/ui/widgets/select_chair_widgets/selected_seats_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedSeatsBarBuilder extends StatelessWidget {
  const SelectedSeatsBarBuilder({super.key, this.onNext});

  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectChairCubit, SelectChairState>(
      builder: (context, state) {
        final selectedLabels = state.selectedSeatLabels;

        return SelectedSeatsBar(
          selectedSeatLabels: selectedLabels,
          totalPrice: state.totalPrice,
          onProceed: () {
            if (selectedLabels.isEmpty) return;
            onNext?.call();
          },
        );
      },
    );
  }
}
