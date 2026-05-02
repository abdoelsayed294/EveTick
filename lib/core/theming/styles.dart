import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/font_weight_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextStyles {
  static TextStyle font18DarkBlueBold = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorsManager.darkBlue,
  );
  static TextStyle font24WhiteBold = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeightHelper.bold,
    color: ColorsManager.defaultWhite,
  );
  static TextStyle font16LightGrayRegualr = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.regular,
    color: ColorsManager.lightGray,
  );
  static TextStyle font16WhiteMid = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeightHelper.medium,
    color: ColorsManager.defaultWhite,
  );
}
