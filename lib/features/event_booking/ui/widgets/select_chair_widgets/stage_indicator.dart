import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StageIndicator extends StatelessWidget {
  const StageIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _StageClipper(),
      child: Container(
        width: 300.w,
        height: 48.h,
        color: ColorsManager.lightBlue,
        alignment: Alignment.center,
        child: Text('STAGE', style: TextStyles.font16WhiteRegular(context)),
      ),
    );
  }
}

class _StageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final double inset = size.width * 0.08;

    return Path()
      ..moveTo(inset, 0)
      ..lineTo(size.width - inset, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
