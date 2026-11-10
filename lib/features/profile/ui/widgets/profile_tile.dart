import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ProfileTile extends StatelessWidget {
  final String? iconPath;
  final IconData? icon;
  final TextStyle? titleStyle;
  final String title;
  final String? subtitle;
  final String? trailingText;
  final VoidCallback? onTap;
  
  const ProfileTile({
    super.key,
    this.iconPath,
    this.icon,
    this.titleStyle,
    required this.title,
    this.subtitle,
    this.trailingText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 44.w,
          height: 42.h,
          decoration: BoxDecoration(
            color: context.colors.textBackground,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: icon != null
                ? Icon(icon, color: ColorsManager.red, size: 22.sp)
                : SvgPicture.asset(iconPath!, fit: BoxFit.contain),
          ),
        ),
        title: Text(
          title,
          style: titleStyle ?? TextStyles.font16WhiteRegular(context),
        ),
        subtitle: subtitle == null
      ? null
      : Text(
          subtitle!,
          style: TextStyles.font12LightGrayRegular(context),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (trailingText != null) ...[
              Text(trailingText!, style: TextStyles.font12LightGrayRegular(context)),
              horizontalSpace(8.w),
            ],
            Icon(Icons.arrow_forward_ios_rounded, color: context.colors.lightGray),
          ],
        ),
      ),
    );
  }
}
