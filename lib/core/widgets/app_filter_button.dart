import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Square "filters" button next to a search field.
/// [isActive] (panel open) shows the dark version.
class AppFilterButton extends StatelessWidget {
  const AppFilterButton({super.key, required this.onTap, this.isActive = false});

  final VoidCallback onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 52.w,
        height: 52.w,
        decoration: BoxDecoration(
          color: isActive ? context.colors.textBackground : ColorsManager.orange,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(
          Icons.tune,
          size: 26.sp,
          color: isActive ? ColorsManager.orange : ColorsManager.white,
        ),
      ),
    );
  }
}
