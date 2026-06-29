import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ProfileTile extends StatelessWidget {
  final String iconPath;
  final String title;
  final String? subtitle;
  final String? trailingText;

  ProfileTile({
    super.key,
    required this.iconPath,
    required this.title,
    this.subtitle,
    this.trailingText,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 44.w,
        height: 42.h,
        decoration: BoxDecoration(
          color: ColorsManager.textBackround,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SvgPicture.asset(iconPath, fit: BoxFit.contain),
        ),
      ),
      title: Text(title, style: TextStyles.font16WhiteRegular),
      subtitle: subtitle == null
    ? null
    : Text(
        subtitle!,
        style: TextStyles.font12LightGrayRegular,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null) ...[
            Text(trailingText!, style: TextStyles.font12LightGrayRegular),
            horizontalSpace(8.w),
          ],
          Icon(Icons.arrow_forward_ios_rounded, color: ColorsManager.lightGray),
        ],
      ),
    );
  }
}
