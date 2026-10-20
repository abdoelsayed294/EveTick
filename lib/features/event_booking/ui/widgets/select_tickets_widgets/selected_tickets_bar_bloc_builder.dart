import 'package:evetick/core/services/toast/app_toast.dart';
import 'package:evetick/features/event_booking/logic/select_chair/select_chair_cubit.dart';
import 'package:evetick/features/event_booking/logic/select_chair/select_chair_state.dart';
import 'package:evetick/features/event_booking/logic/select_tickets/select_tickets_cubit.dart';
import 'package:evetick/features/event_booking/logic/select_tickets/select_tickets_state.dart';
import 'package:evetick/features/event_booking/ui/widgets/select_tickets_widgets/selected_tickets_bar.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedTicketsBarBlocBuilder extends StatelessWidget {
  const SelectedTicketsBarBlocBuilder({super.key, this.onNext});

  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectTicketsCubit, SelectTicketsState>(
      builder: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        final tickets = state.mapOrNull(success: (s) => s);
        final totalQuantity = tickets?.totalQuantity ?? 0;

        final skipsSeats = context
            .watch<SelectChairCubit>()
            .state
            .maybeMap(success: (s) => !s.isSeated, orElse: () => false);

        return SelectedTicketsBar(
          buttonText: skipsSeats
              ? l10n.ticketsContinueToCheckout
              : l10n.bookingContinueToSelectSeats,
          ticketCount: totalQuantity,
          totalPrice: tickets?.totalPrice ?? 0.0,
          onNext: () {
            if (totalQuantity == 0) {
              AppToast.error(l10n.bookingSelectTicket);
              return;
            }
            onNext?.call();
          },
        );
      },
    );
  }
}
