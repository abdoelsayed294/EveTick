import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class LogoAndHook extends StatelessWidget {
  const LogoAndHook({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(child: SvgPicture.asset('assets/svgs/dark_logo.svg')),
        verticalSpace(4),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
            children: [
              TextSpan(text: 'Discover Events\nYou '),
              TextSpan(
                text: 'Love',
                style: TextStyle(color: ColorsManager.orange),
              ),
            ],
          ),
        ),
        verticalSpace(8),
        Text(
          'Join the community of event seekers',
          style: TextStyles.font16LightGrayRegular,
        ),
      ],
    );
  }
}
