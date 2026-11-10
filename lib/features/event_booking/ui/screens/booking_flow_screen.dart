import 'package:evetick/core/helpers/section_resolver.dart';
import 'package:evetick/core/routing/routes.dart';
import 'package:evetick/core/services/toast/app_toast.dart';
import 'package:evetick/features/event_booking/data/models/confirmation_args.dart';
import 'package:evetick/features/event_booking/logic/checkout/checkout_cubit.dart';
import 'package:evetick/features/event_booking/logic/checkout/checkout_state.dart';
import 'package:evetick/features/event_booking/logic/select_chair/select_chair_cubit.dart';
import 'package:evetick/features/event_booking/logic/select_chair/select_chair_state.dart';
import 'package:evetick/features/event_booking/logic/select_tickets/select_tickets_cubit.dart';
import 'package:evetick/features/event_booking/logic/select_tickets/select_tickets_state.dart';
import 'package:evetick/features/event_booking/ui/widgets/booking_flow_widgets/booking_app_bar_bloc_builder.dart';
import 'package:evetick/features/event_booking/ui/widgets/booking_flow_widgets/booking_pages_bloc_builder.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingFlowScreen extends StatefulWidget {
  const BookingFlowScreen({super.key});

  @override
  State<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends State<BookingFlowScreen> {
  late final PageController _pageController;

  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    final isSeated = context.read<SelectChairCubit>().state.isSeatedFlow;
    final totalSteps = isSeated ? 3 : 2;
    if (_currentStep < totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  void _onPageChanged(int index) {
    setState(() => _currentStep = index);
  }

  void _onTicketsNext() {
    final l10n = AppLocalizations.of(context)!;
    final chairState = context.read<SelectChairCubit>().state;

    final chairError = chairState.mapOrNull(error: (e) => e.error);
    if (chairError != null) {
      AppToast.error(
        chairError.isEmpty ? l10n.bookingCouldNotLoadEvent : chairError,
      );
      return;
    }

    final chair = chairState.mapOrNull(success: (s) => s);
    if (chair == null) {
      AppToast.error(l10n.bookingLoadingEventDetails);
      return;
    }

    final tickets = context
        .read<SelectTicketsCubit>()
        .state
        .mapOrNull(success: (s) => s);
    if (tickets == null) return;

    if (chair.isSeated) {
      context.read<SelectChairCubit>().setTicketSelection(
            count: tickets.totalQuantity,
            totalPrice: tickets.totalPrice,
          );
    } else {
      final selected = tickets.selectedTickets;
      context.read<CheckoutCubit>().setSelection(
            tickets: selected,
            seats: const [],
            ticketSections: [
              for (final t in selected)
                resolveSectionName(
                  ticketName: t.tier.name,
                  tierIndex: t.tierIndex,
                  tiersCount: tickets.ticketTiers.length,
                  sectionNames: chair.sectionNames,
                ),
            ],
          );
    }
    _nextStep();
  }

  void _onSeatsNext() {
    final tickets = context
            .read<SelectTicketsCubit>()
            .state
            .mapOrNull(success: (s) => s.selectedTickets) ??
        const [];
    final seats = context
            .read<SelectChairCubit>()
            .state
            .mapOrNull(success: (s) => s.selectedSeats) ??
        const [];

    context.read<CheckoutCubit>().setSelection(tickets: tickets, seats: seats);
    _nextStep();
  }

  void _onOrderPlaced(String orderId) {
    final checkout =
        context.read<CheckoutCubit>().state.mapOrNull(success: (s) => s);
    if (checkout == null) return;

    Navigator.of(context).pushReplacementNamed(
      Routes.confirmationScreen,
      arguments: ConfirmationArgs(
        orderId: orderId,
        eventTitle: checkout.event.title,
        totalPaid: checkout.pricing.total,
        paidAt: DateTime.now(),
        coverImageUrl: checkout.event.coverImageUrl,
        location: checkout.event.location,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BookingAppBarBlocBuilder(
        currentStep: _currentStep,
        onPrevious: _previousStep,
      ),
      body: BookingPagesBlocBuilder(
        pageController: _pageController,
        onPageChanged: _onPageChanged,
        onTicketsNext: _onTicketsNext,
        onSeatsNext: _onSeatsNext,
        onOrderPlaced: _onOrderPlaced,
      ),
    );
  }
}
