import 'package:evetick/core/helpers/count_formatter.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/features/organizer_profile/data/models/organizer_profile_model.dart';
import 'package:evetick/features/organizer_profile/ui/widgets/organizer_stat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrganizerProfileInfo extends StatelessWidget {
  const OrganizerProfileInfo({super.key, required this.profile});

  final OrganizerProfile profile;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bio = profile.bio;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12.h),
        Row(
          children: [
            Flexible(
              child: Text(
                profile.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.white,
                ),
              ),
            ),
            if (profile.isVerified) ...[
              SizedBox(width: 8.w),
              Icon(
                Icons.verified_outlined,
                size: 22.sp,
                color: ColorsManager.orange,
              ),
            ],
          ],
        ),
        if (bio != null) ...[
          SizedBox(height: 12.h),
          Text(
            bio,
            style: TextStyle(
              fontSize: 15.sp,
              height: 1.5,
              color: colors.lightGray,
            ),
          ),
        ],
        SizedBox(height: 20.h),
        Row(
          children: [
            Expanded(
              child: OrganizerStatCard(
                value: '${profile.eventsHosted}',
                label: 'Events Hosted',
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: OrganizerStatCard(
                value: formatCount(profile.followers),
                label: 'Followers',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
