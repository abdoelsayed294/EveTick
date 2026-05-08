import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/styles.dart';
import 'package:evetick/features/onboarding/presentation/widgets/CustomButton.dart';
import 'package:evetick/features/onboarding/presentation/widgets/custom_indicator.dart';
import 'package:evetick/features/onboarding/presentation/widgets/image_gradient.dart';
import 'package:evetick/features/onboarding/presentation/widgets/onboarding2_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Onboarding2Screen extends StatelessWidget {
  final VoidCallback onNext;
  final int currentIndex;
  const Onboarding2Screen({
    super.key,
    required this.onNext,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Onboarding2Image(),
            Positioned.fill(
              child: Container(
                color: ColorsManager.darkBlue.withValues(alpha: 0.2),
              ),
            ),
            ImageGradient(),
            Positioned(
              top: 507.h,
              left: 16.w,
              right: 16.w,
              child: Text(
                'Seamless Booking',
                style: TextStyles.font24WhiteBold,
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              top: 558.h,
              left: 16.w,
              right: 16.w,
              child: Text(
                'Secure your spot in seconds with our fast and easy checkout process',
                style: TextStyles.font16LightGrayRegular,
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              top: 628.h,
              left: 162.5.w,
              right: 162.5.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  CustomIndicator(active: currentIndex == 0),
                  SizedBox(width: 5.w),
                  CustomIndicator(active: currentIndex == 1),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 675.h, left: 16.w, right: 16.w),
              child: CustomButton(action: 'Next', width: 343.w, onTap: onNext),
            ),
          ],
        ),
      ),
    );
  }
}
