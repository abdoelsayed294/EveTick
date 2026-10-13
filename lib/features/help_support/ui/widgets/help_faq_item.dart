import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/features/help_support/data/models/help_faq_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HelpFaqItem extends StatelessWidget {
  final HelpFaqModel faq;
  final bool isExpanded;
  final VoidCallback onTap;

  const HelpFaqItem({
    super.key,
    required this.faq,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    faq.question,
                    style: TextStyles.font16WhiteRegular(context),
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: context.colors.lightGray,
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.topCenter,
          child: isExpanded
              ? Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: Text(
                      faq.answer,
                      style: TextStyles.font14LightGrayRegular(context),
                    ),
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),
        Divider(height: 1, color: context.colors.lightBlue),
      ],
    );
  }
}
