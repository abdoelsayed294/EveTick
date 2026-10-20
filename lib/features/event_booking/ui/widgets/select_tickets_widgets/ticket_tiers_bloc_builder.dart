import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/widgets/app_error_view.dart';
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
        return state.maybeMap(
          success: (s) {
            final cubit = context.read<SelectTicketsCubit>();
            return Column(
              children: [
                for (var i = 0; i < s.ticketTiers.length; i++) ...[
                  TicketTypeContainer(
                    name: s.ticketTiers[i].name,
                    description: s.ticketTiers[i].description,
                    price: s.ticketTiers[i].price,
                    quantity: s.quantities[i],
                    canIncrease: cubit.canIncrease(i),
                    isSoldOut: s.ticketTiers[i].quantity == 0,
                    onIncrease: () => cubit.increase(i),
                    onDecrease: () => cubit.decrease(i),
                  ),
                  verticalSpace(16),
                ],
              ],
            );
          },
          error: (e) => AppErrorView(message: e.error),
          orElse: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}
