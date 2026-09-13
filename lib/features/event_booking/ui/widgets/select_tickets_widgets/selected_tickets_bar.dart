import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/core/widgets/filled_app_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectedTicketsBar extends StatelessWidget {
  const SelectedTicketsBar({super.key, this.onNext});

  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
            width: double.infinity,

            padding: EdgeInsets.only(
              left: 16.w,
              bottom: 32.h,
              right: 16.w,
              top: 16.h,
            ),
            decoration: BoxDecoration(
              color: context.colors.lightBlue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '1 ticket selected',
                          style: TextStyles.font12LightGrayRegular(context),
                        ),
                        verticalSpace(8),
                        Text(
                          '\$158.00',
                          style: TextStyles.font18WhiteBold(context),
                        ),
                      ],
                    ),

                    Text(
                      'TOTAL PRICE \n + Service fee',
                      style: TextStyles.font12LightGrayRegular(context),
                    ),
                  ],
                ),

                verticalSpace(24),

                FilledAppTextButton(
                  buttonText: 'Continue to select Chair',
                  onPressed: onNext!,
                ),
              ],
            ),
          );
  }
}