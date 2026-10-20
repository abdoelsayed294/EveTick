import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/features/event_booking/ui/widgets/select_tickets_widgets/event_title_bloc_builder.dart';
import 'package:evetick/features/event_booking/ui/widgets/select_tickets_widgets/selected_tickets_bar_bloc_builder.dart';
import 'package:evetick/features/event_booking/ui/widgets/select_tickets_widgets/ticket_tiers_bloc_builder.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectTicketsScreen extends StatelessWidget {
  const SelectTicketsScreen({super.key, this.onNext});

  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.bookingFor,
                      style: TextStyles.font16GrayRegular,
                    ),
                    verticalSpace(4),
                    const EventTitleBlocBuilder(),
                    verticalSpace(24),
                    const TicketTiersBlocBuilder(),
                  ],
                ),
              ),
            ),
          ),
          SelectedTicketsBarBlocBuilder(onNext: onNext),
        ],
      ),
    );
  }
}
