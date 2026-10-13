import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchBackButton extends StatelessWidget {
  const SearchBackButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Icon(
          Icons.arrow_back_ios_new,
          size: 22.sp,
          color: context.colors.white,
        ),
      ),
    );
  }
}
