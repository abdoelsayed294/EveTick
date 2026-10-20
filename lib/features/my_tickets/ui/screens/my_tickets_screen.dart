import 'package:evetick/core/helpers/extentions.dart';
import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/routing/routes.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/core/widgets/app_empty_view.dart';
import 'package:evetick/core/widgets/app_error_view.dart';
import 'package:evetick/features/my_tickets/logic/my_tickets_cubit.dart';
import 'package:evetick/features/my_tickets/logic/my_tickets_state.dart';
import 'package:evetick/features/my_tickets/ui/widgets/my_ticket_card.dart';
import 'package:evetick/features/my_tickets/ui/widgets/my_tickets_tab_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evetick/l10n/app_localizations.dart';

class MyTicketsScreen extends StatelessWidget {
  const MyTicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<MyTicketsCubit, MyTicketsState>(
          builder: (context, state) {
            final cubit = context.read<MyTicketsCubit>();

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  verticalSpace(30),
                  Text(
                    AppLocalizations.of(context)!.myTicketsTitle,
                    style: TextStyles.font18WhiteBold(context),
                  ),
                  verticalSpace(24),
                  MyTicketsTabSwitch(
                    selected: state.tab,
                    onSelected: cubit.selectTab,
                  ),
                  verticalSpace(16),
                  Expanded(child: _buildBody(context, state, cubit)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    MyTicketsState state,
    MyTicketsCubit cubit,
  ) {
    switch (state.status) {
      case MyTicketsStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case MyTicketsStatus.error:
        return AppErrorView(message: state.errorMessage, onRetry: cubit.load);
      case MyTicketsStatus.success:
        final tickets = state.visibleTickets;
        final isPast = state.tab == MyTicketsTab.past;

        return RefreshIndicator(
          onRefresh: () => cubit.load(silent: true),
          child: tickets.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: 200.h),
                    AppEmptyView(
                      message:
                          isPast
                              ? AppLocalizations.of(context)!.myTicketsNoPast
                              : AppLocalizations.of(context)!.myTicketsNoUpcoming,
                    ),
                  ],
                )
              : ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  // Room for the floating navbar.
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
}
