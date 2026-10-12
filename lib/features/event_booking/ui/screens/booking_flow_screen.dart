import 'package:evetick/features/event_booking/ui/screens/checkout_screen.dart';
import 'package:evetick/features/event_booking/ui/screens/select_chair_screen.dart';
import 'package:evetick/features/event_booking/ui/screens/select_tickets_screen.dart';
import 'package:evetick/features/event_booking/ui/widgets/custom_app_bar.dart';
import 'package:evetick/core/routing/routes.dart';
import 'package:evetick/features/event_booking/data/models/confirmation_args.dart';
import 'package:evetick/features/event_booking/logic/checkout/checkout_cubit.dart';
import 'package:evetick/features/event_booking/logic/select_chair/select_chair_cubit.dart';
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

  final int totalSteps = 3;

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
    if (_currentStep < totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Hand the chosen tickets over to the seat step, then move on.
  void _onTicketsNext() {
    final tickets = context.read<SelectTicketsCubit>().state;
    context.read<SelectChairCubit>().setTicketSelection(
          count: tickets.totalQuantity,
          totalPrice: tickets.totalPrice,
        );
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
    return Scaffold(
      appBar: CustomAppBar(
        title: _getAppBarTitle(),
        stepNum: _currentStep + 1,
        onPrevious: _previousStep,
      ),

      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,

        
        physics: const NeverScrollableScrollPhysics(),

        children: [
          SelectTicketsScreen(
            onNext: _onTicketsNext,
          ),

          SelectChairScreen(
            onNext: _onSeatsNext,
          ),

          CheckoutScreen(
            onOrderPlaced: _onOrderPlaced,
          ),
        ],
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_currentStep) {
      case 0:
        return 'Select Tickets';

      case 1:
        return 'Main Arena Hall';

      case 2:
        return 'Checkout';

      default:
        return '';
    }
  }
}