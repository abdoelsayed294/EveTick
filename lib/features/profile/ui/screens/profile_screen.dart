import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/styles.dart';
import 'package:evetick/core/widgets/filled_app_text_button.dart';
import 'package:evetick/core/widgets/outline_app_text_button.dart';
import 'package:evetick/features/profile/ui/widgets/profile_image.dart';
import 'package:evetick/features/profile/ui/widgets/profile_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 16.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text('My Profile', style: TextStyles.font18WhiteBold),
                ),
                verticalSpace(24.h),
                ProfileImage(),
                verticalSpace(16.h),
                Text('Abdelrhman Elsayed', style: TextStyles.font18WhiteBold),
                verticalSpace(4.h),
                Text(
                  'Premium Attendee',
                  style: TextStyles.font16LightGrayRegular,
                ),
                verticalSpace(16.h),
                FilledAppTextButton(
                  buttonWidth: 151.w,
                  buttonText: 'Edit Profile',
                  onPressed: () {},
                ),
                verticalSpace(24),
                ProfileSection(
                  sectionTitle: 'Account',
                  firstIconPath: 'assets/icons/personal_info.svg',
                  secondIconPath: 'assets/icons/following_organizers.svg',
                  firstTitle: 'Personal Info',
                  secondTitle: 'Following Organizers',
                  firstSubtitle: 'Email, Phone, Address',
                ),
                verticalSpace(24),
                ProfileSection(
                  sectionTitle: 'Perferences',
                  firstIconPath: 'assets/icons/language.svg',
                  secondIconPath: 'assets/icons/appearance.svg',
                  firstTitle: 'Language',
                  secondTitle: 'Appearance',
                  firstTrailingText: 'English(US)',
                  secondTrailingText: 'Dark Mode',
                ),
                verticalSpace(24),
                ProfileSection(
                  sectionTitle: 'Support',
                  firstIconPath: 'assets/icons/help_center.svg',
                  secondIconPath: 'assets/icons/terms_of_service.svg',
                  firstTitle: 'Help Center',
                  secondTitle: 'Terms of Service',
                ),
                verticalSpace(24),
                OutlineAppTextButton(
                  buttonText: 'Log Out',
                  onPressed: () {},
                  borderColor: ColorsManager.red,
                  textStyle: TextStyles.font16RedMid,
                  buttonWidth: 193.w,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
