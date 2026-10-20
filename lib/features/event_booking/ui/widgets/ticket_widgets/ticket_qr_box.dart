import 'package:evetick/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketQrBox extends StatelessWidget {
  const TicketQrBox({super.key, required this.data});

  final String data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: ColorsManager.defaultWhite,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColorsManager.lightGray, width: 2),
      ),
      child: QrImageView(
        data: data,
        size: 160.w,
        padding: EdgeInsets.zero,
        backgroundColor: ColorsManager.defaultWhite,
      ),
    );
  }
}
