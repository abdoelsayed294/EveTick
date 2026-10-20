import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/widgets/filled_app_text_button.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// "Price per ticket" + Book Now (same bar style as the booking steps).
class EventDetailsBottomBar extends StatelessWidget {
  const EventDetailsBottomBar({
    super.key,
    required this.priceText,
    required this.isSoldOut,
    required this.onBook,
  });

  final String priceText;
  final bool isSoldOut;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 32.h),
      decoration: BoxDecoration(
        color: context.colors.lightBlue,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context)!.eventDetailsPricePerTicket,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: context.colors.lightGray,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  priceText.isEmpty ? '--' : priceText,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: context.colors.white,
                  ),
                ),
              ],
            ),
          ),
          FilledAppTextButton(
            buttonText: isSoldOut
                ? AppLocalizations.of(context)!.commonSoldOut
                : AppLocalizations.of(context)!.commonBookNow,
            buttonWidth: 160.w,
            backgroundColor: isSoldOut ? ColorsManager.gray3 : null,
            onPressed: isSoldOut ? () {} : onBook,
          ),
        ],
      ),
    );
  }
}
