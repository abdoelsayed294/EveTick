import 'package:evetick/features/event_booking/ui/screens/checkout_screen.dart';
import 'package:evetick/features/event_booking/ui/screens/select_chair_screen.dart';
import 'package:evetick/features/event_booking/ui/screens/select_tickets_screen.dart';
import 'package:evetick/features/event_booking/ui/widgets/custom_app_bar.dart';
import 'package:evetick/core/helpers/section_resolver.dart';
import 'package:evetick/core/routing/routes.dart';
import 'package:evetick/features/event_booking/data/models/confirmation_args.dart';
import 'package:evetick/features/event_booking/logic/checkout/checkout_cubit.dart';
import 'package:evetick/features/event_booking/logic/select_chair/select_chair_cubit.dart';
import 'package:evetick/features/event_booking/logic/select_chair/select_chair_state.dart';
import 'package:evetick/features/event_booking/logic/select_tickets/select_tickets_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingFlowScreen extends StatefulWidget {
  const BookingFlowScreen({
    super.key,
  });

  @override
  State<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends State<BookingFlowScreen> {
  late final PageController _pageController;

  int _currentStep = 0;

  /// Seated events: tickets -> seats -> checkout.
  /// Other events (sections): tickets -> checkout.
  /// Until the layout is loaded we assume the seated flow.
  bool _isSeated(SelectChairState chair) =>
      chair.status != SelectChairStatus.success || chair.isSeated;

  int _totalSteps(SelectChairState chair) => _isSeated(chair) ? 3 : 2;

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
    final chair = context.read<SelectChairCubit>().state;
    if (_currentStep < _totalSteps(chair) - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  /// Seated events: hand the tickets to the seat step.
  /// Sections events: no seats, hand everything to checkout directly.
  void _onTicketsNext() {
    final chair = context.read<SelectChairCubit>().state;
    if (chair.status == SelectChairStatus.loading) {
      _showMessage('Loading event details, try again in a moment');
      return;
    }
    if (chair.status == SelectChairStatus.error) {
      _showMessage(chair.errorMessage ?? 'Could not load the event');
      return;
    }

    final tickets = context.read<SelectTicketsCubit>().state;

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

  /// Hand tickets + seats to the checkout step, then move on.
  void _onSeatsNext() {
    final tickets = context.read<SelectTicketsCubit>().state.selectedTickets;
    final seats = context.read<SelectChairCubit>().state.selectedSeats;
    context.read<CheckoutCubit>().setSelection(tickets: tickets, seats: seats);
    _nextStep();
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
    setState(() {
      _currentStep = index;
    });
  }

  /// Payment done: replace the flow with the confirmation screen
  /// so "back" never returns to the checkout.
  void _onOrderPlaced() {
    final checkout = context.read<CheckoutCubit>().state;
    final event = checkout.event;
    final orderId = checkout.orderId;
    if (event == null || orderId == null) return;

    Navigator.of(context).pushReplacementNamed(
      Routes.confirmationScreen,
      arguments: ConfirmationArgs(
        orderId: orderId,
        eventTitle: event.title,
        totalPaid: checkout.pricing.total,
        paidAt: DateTime.now(),
        coverImageUrl: event.coverImageUrl,
        location: event.location,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectChairCubit, SelectChairState>(
      builder: (context, chair) {
        final isSeated = _isSeated(chair);
        final stepTitles = isSeated
            ? const ['Ticket Selection', 'Seat Selection', 'Checkout']
            : const ['Ticket Selection', 'Checkout'];

        return Scaffold(
          appBar: CustomAppBar(
            title: _getAppBarTitle(isSeated),
            stepNum: _currentStep + 1,
            stepTitles: stepTitles,
            onPrevious: _previousStep,
          ),
          body: PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              SelectTicketsScreen(onNext: _onTicketsNext),
              if (isSeated) SelectChairScreen(onNext: _onSeatsNext),
              CheckoutScreen(onOrderPlaced: _onOrderPlaced),
            ],
          ),
        );
      },
    );
  }

  String _getAppBarTitle(bool isSeated) {
    if (_currentStep == 0) return 'Select Tickets';
    final isCheckout = _currentStep == (isSeated ? 2 : 1);
    return isCheckout ? 'Checkout' : 'Select Seats';
  }
}
