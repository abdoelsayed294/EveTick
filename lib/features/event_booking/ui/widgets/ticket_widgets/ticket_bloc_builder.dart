import 'package:evetick/core/widgets/app_error_view.dart';
import 'package:evetick/features/event_booking/logic/ticket/ticket_cubit.dart';
import 'package:evetick/features/event_booking/logic/ticket/ticket_state.dart';
import 'package:evetick/features/event_booking/ui/widgets/ticket_widgets/ticket_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TicketBlocBuilder extends StatelessWidget {
  const TicketBlocBuilder({super.key, required this.backgroundColor});

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TicketCubit, TicketState>(
      builder: (context, state) {
        return state.maybeMap(
          success: (s) => TicketContent(
            ticket: s.ticket,
            backgroundColor: backgroundColor,
          ),
          error: (e) => AppErrorView(message: e.error),
          orElse: () => const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
