import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/features/my_tickets/ui/widgets/my_tickets_bloc_builder.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evetick/l10n/app_localizations.dart';

class MyTicketsScreen extends StatelessWidget {
  const MyTicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              verticalSpace(30),
              Text(
                AppLocalizations.of(context)!.myTicketsTitle,
                style: TextStyles.font18WhiteBold(context),
              ),
              verticalSpace(24),
              const Expanded(child: MyTicketsBlocBuilder()),
            ],
          ),
        ),
      ),
    );
  }
}
