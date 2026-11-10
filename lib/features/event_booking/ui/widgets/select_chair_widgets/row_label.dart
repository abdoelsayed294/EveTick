import 'package:evetick/core/theming/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RowLabel extends StatelessWidget {
  const RowLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24.w,
      height: 24.h,
      child: Center(
        child: Text(text, style: TextStyles.font12LightGrayRegular(context)),
      ),
    );
  }
}
