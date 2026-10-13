import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Search box with a clear (x) button while there is text.
class SearchInputField extends StatelessWidget {
  const SearchInputField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    OutlineInputBorder border() => OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        );

    return TextField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: TextInputAction.search,
      style: TextStyle(color: colors.white, fontSize: 16.sp),
      cursorColor: colors.white,
      decoration: InputDecoration(
        hintText: 'Search for concerts, cinema...',
        hintStyle: TextStyle(color: colors.lightGray, fontSize: 14.sp),
        prefixIcon: Icon(Icons.search, color: colors.lightGray),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (_, value, __) => value.text.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  onPressed: onClear,
                  icon: Icon(Icons.cancel_outlined, color: colors.lightGray),
                ),
        ),
        filled: true,
        fillColor: colors.lightBlue,
        contentPadding: EdgeInsets.symmetric(vertical: 16.h),
        border: border(),
        enabledBorder: border(),
        focusedBorder: border(),
      ),
    );
  }
}
