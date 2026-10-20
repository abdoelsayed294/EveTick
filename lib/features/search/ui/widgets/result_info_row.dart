import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResultInfoRow extends StatelessWidget {
  const ResultInfoRow({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final color = context.colors.lightGray;

    return Row(
      children: [
        Icon(icon, size: 20.sp, color: color),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14.sp, color: color),
          ),
        ),
      ],
    );
  }
}
