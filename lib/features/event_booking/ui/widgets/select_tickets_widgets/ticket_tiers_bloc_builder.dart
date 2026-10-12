import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/features/event_booking/logic/select_tickets/select_tickets_cubit.dart';
import 'package:evetick/features/event_booking/logic/select_tickets/select_tickets_state.dart';
import 'package:evetick/features/event_booking/ui/widgets/select_tickets_widgets/ticket_type_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TicketTiersBlocBuilder extends StatelessWidget {
  const TicketTiersBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectTicketsCubit, SelectTicketsState>(
      builder: (context, state) {
        switch (state.status) {
          case SelectTicketsStatus.loading:
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            );
          case SelectTicketsStatus.error:
            return Center(
              child: Text(
                state.errorMessage ?? 'Something went wrong',
                style: const TextStyle(color: Colors.red),
              ),
            );
          case SelectTicketsStatus.success:
            final cubit = context.read<SelectTicketsCubit>();
            return Column(
              children: [
                for (var i = 0; i < state.ticketTiers.length; i++) ...[
                  TicketTypeContainer(
                    name: state.ticketTiers[i].name,
                    description: state.ticketTiers[i].description,
                    price: state.ticketTiers[i].price,
                    quantity: state.quantities[i],
                    canIncrease: cubit.canIncrease(i),
                    isSoldOut: state.ticketTiers[i].quantity == 0,
                    onIncrease: () => cubit.increase(i),
                    onDecrease: () => cubit.decrease(i),
                  ),
                  verticalSpace(16),
                ],
              ],
            );
        }
      },
    );
  }
}
