import 'package:evetick/features/organizer_profile/logic/organizer_profile_cubit.dart';
import 'package:evetick/features/organizer_profile/logic/organizer_profile_data.dart';
import 'package:evetick/features/organizer_profile/ui/widgets/organizer_profile_header.dart';
import 'package:evetick/features/organizer_profile/ui/widgets/organizer_profile_info.dart';
import 'package:evetick/features/organizer_profile/ui/widgets/organizer_tab_content.dart';
import 'package:evetick/features/organizer_profile/ui/widgets/organizer_tab_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrganizerProfileContent extends StatelessWidget {
  const OrganizerProfileContent({super.key, required this.data});

  final OrganizerProfileData data;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OrganizerProfileHeader(data: data),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OrganizerProfileInfo(profile: data.profile),
                SizedBox(height: 20.h),
                OrganizerTabSwitch(
                  selected: data.tab,
                  onSelected: context.read<OrganizerProfileCubit>().selectTab,
                ),
                SizedBox(height: 20.h),
                OrganizerTabContent(tab: data.tab, profile: data.profile),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
