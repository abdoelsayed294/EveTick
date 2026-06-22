import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/styles.dart';
import 'package:evetick/core/widgets/filled_app_text_button.dart';
import 'package:evetick/features/auth/ui/widgets/verification_widgets/check_email_text.dart';
import 'package:evetick/features/auth/ui/widgets/verification_widgets/didnt_receive_the_code.dart';
import 'package:evetick/features/auth/ui/widgets/verification_widgets/digit_verification_code_frame.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 16.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
                      color: ColorsManager.white,
                      size: 24.sp,
                    ),
                    horizontalSpace(121),
                    Text('Verify', style: TextStyles.font18WhiteBold),
                  ],
                ),
                verticalSpace(56),
                SizedBox(
                  height: 72.h,
                  child: SvgPicture.asset('assets/svgs/dark_logo.svg'),
                ),
                verticalSpace(56),
                Text('Verifiaction Code', style: TextStyles.font18WhiteBold),
                verticalSpace(16),
                CheckEmailText(),
                verticalSpace(56),
                DigitVerificationCodeFrame(),
                verticalSpace(24),
                DidntReceiveTheCode(),
                verticalSpace(150),
                FilledAppTextButton(buttonText: 'Confirm', onPressed: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
