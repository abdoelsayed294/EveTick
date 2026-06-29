import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/styles.dart';
import 'package:evetick/features/profile/ui/widgets/profile_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ProfileSection extends StatelessWidget {
  final String sectionTitle;
  final String firstIconPath;
  final String secondIconPath;
  final String firstTitle;
  final String secondTitle;
  final String? firstSubtitle;
  final String? secondSubtitle;
  final String? firstTrailingText;
  final String? secondTrailingText;

  ProfileSection({
    super.key,
    required this.sectionTitle,
    required this.firstIconPath,
    required this.secondIconPath,
    required this.firstTitle,
    required this.secondTitle,
    this.firstSubtitle,
    this.secondSubtitle,
    this.firstTrailingText,
    this.secondTrailingText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(sectionTitle, style: TextStyles.font16lightGrayMid),
        verticalSpace(16),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorsManager.lightBlue,
            borderRadius: BorderRadius.circular(13.r),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
            child: Column(
              children: [
                ProfileTile(
                  iconPath: firstIconPath,
                  title: firstTitle,
                  subtitle: firstSubtitle,
                  trailingText: firstTrailingText,
                ),

                Divider(color: ColorsManager.darkBlue, thickness: 1),

                ProfileTile(
                  iconPath: secondIconPath,
                  title: secondTitle,
                  subtitle: secondSubtitle,
                  trailingText: secondTrailingText,
                ),
                
              ],
            ),
          ),
        ),
      ],
    );
  }
}
