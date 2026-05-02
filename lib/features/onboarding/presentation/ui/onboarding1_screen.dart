import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/styles.dart';
import 'package:evetick/features/onboarding/presentation/widgets/CustomButton.dart';
import 'package:evetick/features/onboarding/presentation/widgets/custom_indicator.dart';
import 'package:evetick/features/onboarding/presentation/widgets/image_gradient.dart';
import 'package:evetick/features/onboarding/presentation/widgets/onboarding1_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Onboarding1Screen extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final int currentIndex;
  const Onboarding1Screen({
    super.key,
    required this.onNext,
    required this.onSkip, required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Onboarding1Image(),
            Positioned.fill(
              child: Container(
                color: ColorsManager.darkBlue.withValues(alpha: 0.2),
              ),
            ),
            ImageGradient(),
            Positioned(
              top: 472.h,
              left: 16.w,
              right: 16.w,
              child: Text(
                'Discover Local \n Events',
                style: TextStyles.font24WhiteBold,
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              top: 558.h,
              left: 16.w,
              right: 16.w,
              child: Text(
                'Find and book tickets for concerts, cinema, and more happening right in your city',
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
            Positioned(
              top: 56.h,
              left: 306.w,
              right: 16.w,
              bottom: 740.h,
              child: TextButton(
                onPressed: onSkip,
                child: Text('Skip', style: TextStyles.font16LightGrayRegular),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 16.w,
                right: 16.w,
                top: 676.h,
                bottom: 117.h,
              ),
              child: CustomButton(
                action: 'Next',
                width: double.infinity,
                onTap: onNext,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
