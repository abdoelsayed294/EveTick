import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/features/event_booking/ui/widgets/checkout_widgets/radio_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentMethodTile extends StatelessWidget {
  const PaymentMethodTile({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: double.infinity,
        height: 64.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: context.colors.lightBlue,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? ColorsManager.orange : context.colors.darkGray,
            width: isSelected ? 2 : 0.5,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24.sp, color: context.colors.white),
            horizontalSpace(16),
            Expanded(
              child: Text(label, style: TextStyles.font16WhiteMid(context)),
            ),
            RadioCircle(isSelected: isSelected),
          ]
        ),
      ),
    );
  }
}

