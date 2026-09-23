import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/core/widgets/filled_app_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckoutBottomBar extends StatelessWidget {
  const CheckoutBottomBar({super.key, required this.onPay});

  final VoidCallback onPay;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h, bottom: 32.h),
      decoration: BoxDecoration(
        color: context.colors.lightBlue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline_rounded, size: 16.sp, color: ColorsManager.gray),
              horizontalSpace(4),
              Text(
                'SECURE SSL ENCRYPTED PAYMENT',
                style: TextStyles.font12GrayRegular,
              ),
            ],
          ),
          verticalSpace(8),
          FilledAppTextButton(buttonText: 'Pay Now', onPressed: onPay),
        ],
      ),
    );
  }
}