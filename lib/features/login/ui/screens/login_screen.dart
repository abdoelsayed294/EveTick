import 'package:evetick/core/helpers/extentions.dart';
import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/routing/routes.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/styles.dart';
import 'package:evetick/core/widgets/app_text_button.dart';
import 'package:evetick/core/widgets/app_text_form_field.dart';
import 'package:evetick/features/login/ui/widgets/login_background.dart';
import 'package:evetick/features/login/ui/widgets/login_with_other_platforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const LoginBackground(),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 16.w),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: InkWell(
                        onTap: () {},
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: ColorsManager.white,
                          size: 24.sp,
                        ),
                      ),
                    ),
                    verticalSpace(72),
                    Align(
                      alignment: Alignment.center,
                      child: SvgPicture.asset('assets/svgs/dark_logo.svg'),
                    ),
                    verticalSpace(56),
                    Align(
                      alignment: Alignment.center,
                      child: Text('Sign In', style: TextStyles.font24WhiteBold),
                    ),
                    verticalSpace(8),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Enter your email to continue',
                        style: TextStyles.font16LightGrayRegular,
                      ),
                    ),
                    verticalSpace(32),
                    AppTextFormField(
                      label: 'Email Address',
                      hintText: 'hello@evetick.com',
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: ColorsManager.lightGray,
                        size: 24.sp,
                      ),
                    ),
                    verticalSpace(32),
                    AppTextButton(
                      buttonText: 'Continue',
                      onPressed: () {
                        context.pushNamed(Routes.verificationScreen);
                      },
                    ),
                    verticalSpace(72),
                    LoginWithOtherPlatforms(),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
