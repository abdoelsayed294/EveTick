import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/features/splash/ui/widgets/splash_animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashTitle extends StatelessWidget {
  final SplashAnimations animations;

  const SplashTitle({super.key, required this.animations});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // نفس ألوان اللوجو: E برتقالي و T أبيض (أو كحلي في اللايت)
    final tickColor = isDark ? ColorsManager.white : ColorsManager.darkBlue;

    final baseStyle = TextStyle(
      fontSize: 30.sp,                 // أصغر من 40 عشان ما ينافسش اللوجو
      fontWeight: FontWeight.w800,     // أتخن عشان يطابق بلوكات اللوجو
      letterSpacing: 3,                // تباعد بين الحروف = شكل brand أنضف
      height: 1.1,
    );

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
              padding: EdgeInsets.only(top: 20.h), // مسافة أوسع من اللوجو
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'EVE',
                      style: baseStyle.copyWith(color: ColorsManager.orange),
                    ),
                    TextSpan(
                      text: 'TICK',
                      style: baseStyle.copyWith(color: tickColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}