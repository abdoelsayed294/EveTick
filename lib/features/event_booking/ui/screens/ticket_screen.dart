import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/features/event_booking/ui/widgets/ticket_widgets/ticket_bloc_builder.dart';
import 'package:flutter/material.dart';

class TicketScreen extends StatelessWidget {
  const TicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final background = context.colors.darkBlue;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: context.colors.white),
        title: Text('Your Ticket', style: TextStyles.font18WhiteBold(context)),
      ),
      body: SafeArea(child: TicketBlocBuilder(backgroundColor: background)),
    );
  }
}
