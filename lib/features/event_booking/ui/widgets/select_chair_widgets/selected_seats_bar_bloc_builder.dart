import 'package:evetick/core/services/toast/app_toast.dart';
import 'package:evetick/features/event_booking/logic/select_chair/select_chair_cubit.dart';
import 'package:evetick/features/event_booking/logic/select_chair/select_chair_state.dart';
import 'package:evetick/features/event_booking/ui/widgets/select_chair_widgets/selected_seats_bar.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedSeatsBarBlocBuilder extends StatelessWidget {
  const SelectedSeatsBarBlocBuilder({super.key, this.onNext});

  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectChairCubit, SelectChairState>(
      builder: (context, state) {
        final chair = state.mapOrNull(success: (s) => s);
        final maxSeats = chair?.maxSeats ?? 0;

        return SelectedSeatsBar(
          selectedSeatLabels:
              chair?.selectedSeats.map((seat) => seat.label).toList() ??
                  const [],
          maxSeats: maxSeats,
          totalPrice: chair?.totalPrice ?? 0.0,
          onProceed: () {
            if (chair == null || !chair.isSelectionComplete) {
              AppToast.error(
                AppLocalizations.of(context)!.bookingSelectSeats(maxSeats),
              );
              return;
            }
            onNext?.call();
          },
        );
      },
    );
  }
}
