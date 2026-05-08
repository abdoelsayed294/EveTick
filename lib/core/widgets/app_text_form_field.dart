import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextFormField extends StatelessWidget {
  final String label;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final TextStyle? inputTextStyle;
  final TextStyle? hintStyle;
  final String? hintText;
  final bool? isObscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color? backgroundColor;
  const AppTextFormField({
    super.key,
    required this.label,
    this.contentPadding,
    this.focusedBorder,
    this.enabledBorder,
    this.inputTextStyle,
    this.hintStyle,
    required this.hintText,
    this.isObscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.backgroundColor
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(label, style: TextStyles.font16WhiteRegular),
        verticalSpace(16),
        TextFormField(
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
            contentPadding ??
            EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            focusedBorder:
            focusedBorder ??
            OutlineInputBorder(
              borderSide: BorderSide(color: ColorsManager.orange, width: 1.3),
              borderRadius: BorderRadius.circular(12.0),
            ),
            enabledBorder:
            enabledBorder ??
            OutlineInputBorder(
              borderSide: BorderSide(
                color: ColorsManager.lightBlue,
                width: 1.3,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            filled: true,
            fillColor: backgroundColor ?? ColorsManager.fourthBlue,
            hintStyle: hintStyle ?? TextStyles.font16LightGrayRegular,
            hintText: hintText,
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon           
          ),
          obscureText: isObscureText ?? false,
          style: inputTextStyle ?? TextStyles.font16WhiteRegular,
        ),
      ],
    );
  }
}
