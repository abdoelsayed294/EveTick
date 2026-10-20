import 'package:evetick/features/event_booking/logic/select_chair/select_chair_cubit.dart';
import 'package:evetick/features/event_booking/logic/select_chair/select_chair_state.dart';
import 'package:evetick/features/event_booking/ui/widgets/custom_app_bar.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingAppBarBlocBuilder extends StatelessWidget
    implements PreferredSizeWidget {
  const BookingAppBarBlocBuilder({
    super.key,
    required this.currentStep,
    required this.onPrevious,
  });

  final int currentStep;
  final VoidCallback onPrevious;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectChairCubit, SelectChairState>(
      buildWhen: (previous, current) =>
          previous.isSeatedFlow != current.isSeatedFlow,
      builder: (context, state) {
        final isSeated = state.isSeatedFlow;
        final l10n = AppLocalizations.of(context)!;
        final stepTitles = isSeated
            ? [
                l10n.ticketsStepTicketSelection,
                l10n.bookingSeatSelection,
                l10n.ticketsStepCheckout,
              ]
            : [l10n.ticketsStepTicketSelection, l10n.ticketsStepCheckout];

        return CustomAppBar(
          title: _title(l10n, isSeated),
          stepNum: currentStep + 1,
          stepTitles: stepTitles,
          onPrevious: onPrevious,
        );
      },
    );
  }

  String _title(AppLocalizations l10n, bool isSeated) {
    if (currentStep == 0) return l10n.ticketsSelectTicketsTitle;
    final isCheckout = currentStep == (isSeated ? 2 : 1);
    return isCheckout ? l10n.checkoutTitle : l10n.bookingSelectSeatsTitle;
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 55.h);
}
