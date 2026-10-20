import 'package:evetick/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// The small orange dot shown on notifications that were not opened yet.
class NotificationUnreadDot extends StatelessWidget {
  const NotificationUnreadDot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8.w,
      height: 8.w,
      decoration: const BoxDecoration(
        color: ColorsManager.orange,
        shape: BoxShape.circle,
      ),
    );
  }
}
