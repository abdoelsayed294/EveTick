import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/styles.dart';
import 'package:evetick/core/widgets/filled_app_text_button.dart';
import 'package:evetick/core/widgets/outline_app_text_button.dart';
import 'package:evetick/features/localization/logic/locale_cubit.dart';
import 'package:evetick/features/localization/ui/language_bottom_sheet.dart';
import 'package:evetick/features/profile/ui/widgets/profile_header.dart';
import 'package:evetick/features/profile/ui/widgets/profile_section.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                  child: Text(AppLocalizations.of(context)!.profileMyProfile, style: TextStyles.font18WhiteBold),
                ),
                verticalSpace(24.h),
                ProfileHeader(),
                verticalSpace(16.h),
                FilledAppTextButton(
                  buttonWidth: 151.w,
                  buttonText: AppLocalizations.of(context)!.profileEditProfile,
                  onPressed: () {},
                ),
                verticalSpace(24),
                ProfileSection(
                  sectionTitle: AppLocalizations.of(context)!.profileAccountSection,
                  firstIconPath: 'assets/icons/personal_info.svg',
                  secondIconPath: 'assets/icons/following_organizers.svg',
                  firstTitle: AppLocalizations.of(context)!.profilePersonalInfo,
                  secondTitle: AppLocalizations.of(context)!.profileTabsFollowingOrganizers,
                  firstSubtitle: AppLocalizations.of(context)!.profilePersonalInfoSubtitle,
                ),
                verticalSpace(24),
                ProfileSection(
                  sectionTitle: AppLocalizations.of(context)!.profilePreferencesSection,
                  firstIconPath: 'assets/icons/language.svg',
                  secondIconPath: 'assets/icons/appearance.svg',
                  firstTitle: AppLocalizations.of(context)!.profilePreferencesRowsLanguage,
                  secondTitle: AppLocalizations.of(context)!.profilePreferencesRowsAppearance,
                  firstTrailingText: context.watch<LocaleCubit>().currentLanguageName,
                  secondTrailingText: 'Dark Mode',
                  firstAction: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: ColorsManager.darkBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20.r),
                        ),
                      ),
                      builder: (context) => const LanguageBottomSheet(),
                    );
                  },
                ),
                verticalSpace(24),
                ProfileSection(
                  sectionTitle: AppLocalizations.of(context)!.profileSupportSection,
                  firstIconPath: 'assets/icons/help_center.svg',
                  secondIconPath: 'assets/icons/terms_of_service.svg',
                  firstTitle: AppLocalizations.of(context)!.profileHelpCenter,
                  secondTitle: AppLocalizations.of(context)!.profileTermsOfService,
                ),
                verticalSpace(24),
                OutlineAppTextButton(
                  buttonText: AppLocalizations.of(context)!.profileLogOut,
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
