import 'package:evetick/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum SeatStatus { available, reserved, selected }

class SeatWidget extends StatelessWidget {
  const SeatWidget({super.key, required this.status, this.onTap});

  final SeatStatus status;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool isTappable = status != SeatStatus.reserved;

    return InkWell(
      onTap: isTappable ? onTap : null,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(8.r),
        topRight: Radius.circular(8.r),
      ),
      child: Container(
        width: 24.w,
        height: 24.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.r),
            topRight: Radius.circular(8.r),
          ),
          border: status == SeatStatus.selected
              ? Border.all(color: ColorsManager.black, width: 2)
              : null,
        ),
        child: status == SeatStatus.selected
            ? Icon(Icons.check, color: ColorsManager.white, size: 14.sp)
            : null,
      ),
    );
  }

  Color get _backgroundColor {
    switch (status) {
      case SeatStatus.available:
        return ColorsManager.chairColor;
      case SeatStatus.reserved:
        return ColorsManager.lightBlue;
      case SeatStatus.selected:
        return ColorsManager.orange;
    }
  }
}
