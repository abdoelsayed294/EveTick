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
    return BlocConsumer<SelectTicketsCubit, SelectTicketsState>(
      listener: (context, state) {
        state.whenOrNull(
          error: (error) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(error)));
          },
        );
      },
      builder: (context, state) {
        return state.when(
          initial: () => const SizedBox.shrink(),
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          ),
          success: (ticketTiers) => Column(
            children: [
              for (final tier in ticketTiers) ...[
                TicketTypeContainer(
                  name: tier.name,
                  description: tier.description,
                  price: tier.price,
                  isSoldOut: tier.quantity == 0,
                ),
                verticalSpace(16),
              ],
            ],
          ),
          error: (error) => Center(
            child: Text(error, style: const TextStyle(color: Colors.red)),
          ),
        );
      },
    );
  }
}