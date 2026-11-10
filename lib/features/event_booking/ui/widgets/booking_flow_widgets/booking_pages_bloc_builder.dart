import 'package:evetick/features/event_booking/logic/select_chair/select_chair_cubit.dart';
import 'package:evetick/features/event_booking/logic/select_chair/select_chair_state.dart';
import 'package:evetick/features/event_booking/ui/screens/checkout_screen.dart';
import 'package:evetick/features/event_booking/ui/screens/select_chair_screen.dart';
import 'package:evetick/features/event_booking/ui/screens/select_tickets_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingPagesBlocBuilder extends StatelessWidget {
  const BookingPagesBlocBuilder({
    super.key,
    required this.pageController,
    required this.onPageChanged,
    required this.onTicketsNext,
    required this.onSeatsNext,
    required this.onOrderPlaced,
  });

  final PageController pageController;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onTicketsNext;
  final VoidCallback onSeatsNext;
  final ValueChanged<String> onOrderPlaced;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectChairCubit, SelectChairState>(
      buildWhen: (previous, current) =>
          previous.isSeatedFlow != current.isSeatedFlow,
      builder: (context, state) {
        return PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            SelectTicketsScreen(onNext: onTicketsNext),
            if (state.isSeatedFlow) SelectChairScreen(onNext: onSeatsNext),
            CheckoutScreen(onOrderPlaced: onOrderPlaced),
          ],
        );
      },
    );
  }
}
