import 'package:evetick/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TicketQrButton extends StatelessWidget {
  const TicketQrButton({super.key, required this.isPast, required this.onTap});

  final bool isPast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 48.w,
        height: 48.w,
        decoration: BoxDecoration(
          color: isPast ? ColorsManager.lightGray : ColorsManager.orange,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(
          Icons.qr_code_2,
          size: 32.sp,
          color: isPast ? ColorsManager.darkGray : ColorsManager.white,
        ),
      ),
    );
  }
}
