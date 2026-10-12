import 'package:evetick/features/event_booking/logic/select_tickets/select_tickets_cubit.dart';
import 'package:evetick/features/event_booking/logic/select_tickets/select_tickets_state.dart';
import 'package:evetick/features/event_booking/ui/widgets/select_tickets_widgets/selected_tickets_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedTicketsBarBuilder extends StatelessWidget {
  const SelectedTicketsBarBuilder({super.key, this.onNext});

  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectTicketsCubit, SelectTicketsState>(
      builder: (context, state) {
        return SelectedTicketsBar(
          ticketCount: state.totalQuantity,
          totalPrice: state.totalPrice,
          onNext: () {
            if (state.totalQuantity == 0) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(content: Text('Please select at least one ticket')),
                );
              return;
            }
            onNext?.call();
          },
        );
      },
    );
  }
}
