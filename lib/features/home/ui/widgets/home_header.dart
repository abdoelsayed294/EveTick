import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, this.onNotificationsTap});

  final VoidCallback? onNotificationsTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SvgPicture.asset(
          isDark ? 'assets/svgs/dark_logo.svg' : 'assets/svgs/light_logo.svg',
          height: 40.h,
        ),
        IconButton(
          onPressed: onNotificationsTap,
          icon: Icon(
            Icons.notifications_rounded,
            color: context.colors.white,
            size: 26.sp,
          ),
        ),
      ],
    );
  }
}
