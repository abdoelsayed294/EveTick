import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuantitySelector extends StatefulWidget {
  QuantitySelector({super.key, this.initialQuantity = 0});

  final int initialQuantity;

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.initialQuantity;
  }

  void increase() {
    setState(() {
      quantity++;
    });
  }

  void decrease() {
    if (quantity > 0) {
      setState(() {
        quantity--;
      });
    }
  }

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
                onTap: decrease,
                child: Icon(
                  Icons.remove,
                  color: context.colors.lightGray,
                  size: 24.sp,
                ),
              ),
            ),
          ),

          // number
          Expanded(
            child: Center(
              child: Text(
                '$quantity',
                style: TextStyles.font16WhiteRegular(context),
              ),
            ),
          ),

          // +
          SizedBox(
            width: 44.w,
            height: 44.h,
            child: Material(
              color: ColorsManager.orange,
              borderRadius: BorderRadius.circular(6.r),
              child: InkWell(
                borderRadius: BorderRadius.circular(6.r),
                onTap: increase,
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
