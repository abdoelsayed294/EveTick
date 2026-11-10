import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';

class ThemeTile extends StatelessWidget {
  const ThemeTile({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final ThemeMode value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colors.lightBlue,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: ListTile(
          title: Text(title, style: TextStyles.font16WhiteBold(context)),
          trailing: Radio<ThemeMode>(value: value),
        ),
      ),
    );
  }
}
