import 'package:evetick/features/event_booking/ui/screens/checkout_screen.dart';
import 'package:evetick/features/event_booking/ui/screens/select_chair_screen.dart';
import 'package:evetick/features/event_booking/ui/screens/select_tickets_screen.dart';
import 'package:evetick/features/event_booking/ui/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

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

  void _onPay() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF163352),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Payment Successful',
          style: TextStyle(color: Color(0xFFFAFAFA), fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Your tickets have been booked successfully.',
          style: TextStyle(color: Color(0xFFC9CFD4)),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text(
              'Done',
              style: TextStyle(color: Color(0xFFF05A28), fontWeight: FontWeight.bold),
            ),
          ),
        ],
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
            onNext: _nextStep,
          ),

          SelectChairScreen(
            onNext: _nextStep,
          ),

          CheckoutScreen(
            onPay: _onPay,
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