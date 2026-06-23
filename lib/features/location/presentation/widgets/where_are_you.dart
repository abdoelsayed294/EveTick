import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class WhereAreYou extends StatelessWidget {
  const WhereAreYou({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 116.w,
          height: 100.h,
          child: SvgPicture.asset('assets/svgs/setLocation.svg'),
        ),
        verticalSpace(45),
        Text('Where are You?', style: TextStyles.font18WhiteBold),
        verticalSpace(16),
        Text(
          'To show you events near you , we\n need your location permission',
          style: TextStyles.font16LightGrayRegular,
        ),
      ],
    );
  }
}
