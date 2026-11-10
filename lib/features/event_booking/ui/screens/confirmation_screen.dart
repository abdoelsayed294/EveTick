import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/routing/routes.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/core/widgets/filled_app_text_button.dart';
import 'package:evetick/core/widgets/outline_app_text_button.dart';
import 'package:evetick/features/event_booking/data/models/confirmation_args.dart';
import 'package:evetick/features/event_booking/ui/widgets/confirmation_widgets/event_location_banner.dart';
import 'package:evetick/features/event_booking/ui/widgets/confirmation_widgets/order_details_card.dart';
import 'package:evetick/features/event_booking/ui/widgets/confirmation_widgets/success_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key, required this.args});

  final ConfirmationArgs args;

  void _goHome(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.homeScreen,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasLocation = args.location != null && args.location!.trim().isNotEmpty;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goHome(context);
      },
      child: Scaffold(
        backgroundColor: context.colors.lightBlue,
        appBar: AppBar(
          backgroundColor: context.colors.lightBlue,
          elevation: 0,
          centerTitle: true,
          title: Text('Confirmation', style: TextStyles.font18OrangeBold),
          leading: IconButton(
            icon: Icon(Icons.close, color: context.colors.white),
            onPressed: () => _goHome(context),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  child: Column(
                    children: [
                      const SuccessBadge(),
                      verticalSpace(24),
                      Text(
                        'Payment Successful!',
                        style: TextStyles.font18WhiteBold(context),
                      ),
                      verticalSpace(16),
                      Text.rich(
                        TextSpan(
                          style: TextStyles.font16LightGrayRegular(context),
                          children: [
                            const TextSpan(text: 'Your tickets for '),
                            TextSpan(
                              text: args.eventTitle,
                              style: TextStyles.font16OrangeRegular,
                            ),
                            const TextSpan(text: ' are confirmed.'),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      verticalSpace(24),
                      OrderDetailsCard(args: args),
                      if (hasLocation) ...[
                        verticalSpace(24),
                        EventLocationBanner(
                          location: args.location!.trim(),
                          imageUrl: args.coverImageUrl,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                child: Column(
                  children: [
                    FilledAppTextButton(
                      buttonText: 'View Ticket',
                      onPressed: () => Navigator.of(context).pushNamed(
                        Routes.ticketScreen,
                        arguments: args.orderId,
                      ),
                    ),
                    verticalSpace(12),
                    OutlineAppTextButton(
                      buttonText: 'Back to Home',
                      onPressed: () => _goHome(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
