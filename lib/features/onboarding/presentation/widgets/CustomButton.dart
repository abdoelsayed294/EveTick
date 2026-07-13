import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    super.key,
    required this.action,
    required this.width,
    this.onTap,
  });

  String action;
  double width;
  VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 48.h,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsManager.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.w),
          ),
        ),
        child: Text(
          action,
          style: TextStyle(
            color: context.colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
