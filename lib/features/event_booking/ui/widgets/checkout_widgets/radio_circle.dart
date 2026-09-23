import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RadioCircle extends StatelessWidget {
  const RadioCircle({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20.w,
      height: 20.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? ColorsManager.orange : Colors.transparent,
        border: isSelected
            ? null
            : Border.all(color: context.colors.lightGray, width: 1),
      ),
      child: isSelected
          ? Container(
              width: 8.w,
              height: 8.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colors.white,
              ),
            )
          : null,
    );
  }
}