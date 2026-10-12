import 'package:evetick/core/routing/routes.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/core/widgets/filled_app_text_button.dart';
import 'package:evetick/features/event_booking/logic/ticket/ticket_cubit.dart';
import 'package:evetick/features/event_booking/logic/ticket/ticket_state.dart';
import 'package:evetick/features/event_booking/ui/widgets/ticket_widgets/ticket_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TicketScreen extends StatelessWidget {
  const TicketScreen({super.key});

  void _goHome(BuildContext context) {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(Routes.homeScreen, (route) => false);
  }

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
      body: SafeArea(
        child: BlocBuilder<TicketCubit, TicketState>(
          builder: (context, state) {
            switch (state.status) {
              case TicketStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case TicketStatus.error:
                return Center(
                  child: Text(
                    state.errorMessage ?? 'Something went wrong',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              case TicketStatus.success:
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        child: TicketCard(
                          ticket: state.ticket!,
                          backgroundColor: background,
                        ),
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
          },
        ),
      ),
    );
  }
}
