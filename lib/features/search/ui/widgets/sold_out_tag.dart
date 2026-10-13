import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SoldOutTag extends StatelessWidget {
  const SoldOutTag({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: context.colors.darkBlue,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        'Sold Out',
        style: TextStyle(fontSize: 12.sp, color: ColorsManager.lightGray),
      ),
    );
  }
}
