import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/features/splash/ui/widgets/splash_animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashTitle extends StatelessWidget {
  final SplashAnimations animations;

  const SplashTitle({super.key, required this.animations});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animations.controller,
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(
            0,
            -22.h * animations.lift.value + animations.nameSlide.value,
          ),
          child: Opacity(
            opacity: animations.nameFade.value,
            child: Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Text(
                'EveTick',
                style: TextStyles.font24WhiteBold(
                  context,
                ).copyWith(fontSize: 40.sp),
              ),
            ),
          ),
        );
      },
    );
  }
}
