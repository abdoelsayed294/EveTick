import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/core/widgets/filled_app_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evetick/l10n/app_localizations.dart';

class SelectedTicketsBar extends StatelessWidget {
  const SelectedTicketsBar({
    super.key,
    required this.ticketCount,
    required this.totalPrice,
    required this.onNext,
    required this.buttonText,
  });

  final int ticketCount;
  final double totalPrice;
  final VoidCallback onNext;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 16.w,
        bottom: 32.h,
        right: 16.w,
        top: 16.h,
      ),
      decoration: BoxDecoration(
        color: context.colors.lightBlue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.ticketsTicketCountSelected('$ticketCount'),
                    style: TextStyles.font12LightGrayRegular(context),
                  ),
                  verticalSpace(8),
                  Text(
                    '\$${totalPrice.toStringAsFixed(2)}',
                    style: TextStyles.font18WhiteBold(context),
                  ),
                ],
              ),
              Text(
                '${AppLocalizations.of(context)!.ticketsTotalPrice}\n${AppLocalizations.of(context)!.ticketsPlusServiceFee}',
                style: TextStyles.font12LightGrayRegular(context),
              ),
            ],
          ),
          verticalSpace(24),
          FilledAppTextButton(
            buttonText: buttonText,
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}
