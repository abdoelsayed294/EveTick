import 'package:evetick/core/helpers/extentions.dart';
import 'package:evetick/core/routing/routes.dart';
import 'package:evetick/core/widgets/app_empty_view.dart';
import 'package:evetick/features/my_tickets/logic/my_tickets_cubit.dart';
import 'package:evetick/features/my_tickets/logic/my_tickets_data.dart';
import 'package:evetick/features/my_tickets/logic/my_tickets_tab.dart';
import 'package:evetick/features/my_tickets/ui/widgets/my_ticket_card.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyTicketsList extends StatelessWidget {
  const MyTicketsList({super.key, required this.data});

  final MyTicketsData data;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MyTicketsCubit>();
    final l10n = AppLocalizations.of(context)!;
    final tickets = data.visibleTickets;
    final isPast = data.tab == MyTicketsTab.past;

    return RefreshIndicator(
      onRefresh: () => cubit.load(silent: true),
      child: tickets.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: 200.h),
                AppEmptyView(
                  message: isPast ? l10n.myTicketsNoPast : l10n.myTicketsNoUpcoming,
                ),
              ],
            )
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(bottom: 120.h),
              itemCount: tickets.length,
              separatorBuilder: (_, __) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                final ticket = tickets[index];
                return MyTicketCard(
                  ticket: ticket,
                  onTap: () => context.pushNamed(
                    Routes.ticketScreen,
                    arguments: ticket.orderId,
                  ),
                );
              },
            ),
    );
  }
}
