import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuantitySelector extends StatelessWidget {
  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
    this.canIncrease = true,
  });

  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final bool canIncrease;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 57.h,
      width: 140.w,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 7.w),
      decoration: BoxDecoration(
        color: context.colors.darkBlue,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: InkWell(
                onTap: quantity > 0 ? onDecrease : null,
                child: Icon(
                  Icons.remove,
                  color: quantity > 0
                      ? context.colors.lightGray
                      : context.colors.darkGray,
                  size: 24.sp,
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '$quantity',
                style: TextStyles.font16WhiteRegular(context),
              ),
            ),
          ),
          SizedBox(
            width: 44.w,
            height: 44.h,
            child: Material(
              color: canIncrease
                  ? ColorsManager.orange
                  : ColorsManager.orange.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(6.r),
              child: InkWell(
                borderRadius: BorderRadius.circular(6.r),
                onTap: canIncrease ? onIncrease : null,
                child: Center(
                  child: Icon(
                    Icons.add,
                    color: context.colors.lightGray,
                    size: 24.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
