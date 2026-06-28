import 'package:evetick/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 120.w,
          height: 120.h,
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.r),
            border: Border.all(color: ColorsManager.orange, width: 1.w),
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/profile_image.png',
              fit: BoxFit.cover,
            ),
          ),
        ),

        Positioned(
          bottom: 0,
          right: 8.w,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: 30.w,
              height: 30.h,
              decoration: BoxDecoration(
                color: ColorsManager.orange,
                borderRadius: BorderRadius.circular(100.r),
              ),
              child: Icon(
                Icons.camera_alt_rounded,
                color: ColorsManager.white,
                size: 24.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
