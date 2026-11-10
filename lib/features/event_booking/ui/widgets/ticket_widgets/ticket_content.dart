import 'package:evetick/core/routing/routes.dart';
import 'package:evetick/core/widgets/filled_app_text_button.dart';
import 'package:evetick/features/event_booking/data/models/ticket_model.dart';
import 'package:evetick/features/event_booking/ui/widgets/ticket_widgets/ticket_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TicketContent extends StatelessWidget {
  const TicketContent({
    super.key,
    required this.ticket,
    required this.backgroundColor,
  });

  final TicketModel ticket;

  final Color backgroundColor;

  void _goHome(BuildContext context) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: TicketCard(ticket: ticket, backgroundColor: backgroundColor),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
          child: FilledAppTextButton(
            buttonText: 'Back to Home',
            onPressed: () => _goHome(context),
          ),
        ),
      ],
    );
  }
}
