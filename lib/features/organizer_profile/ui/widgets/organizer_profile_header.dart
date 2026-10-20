import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/features/following_organizers/ui/widgets/follow_button.dart';
import 'package:evetick/features/home/ui/widgets/event_cover_image.dart';
import 'package:evetick/features/organizer_profile/logic/organizer_profile_cubit.dart';
import 'package:evetick/features/organizer_profile/logic/organizer_profile_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrganizerProfileHeader extends StatelessWidget {
  const OrganizerProfileHeader({super.key, required this.data});

  final OrganizerProfileData data;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final profile = data.profile;
    const avatarSize = 96.0;

    return SizedBox(
      height: 200.h + (avatarSize.w / 2),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            height: 200.h,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                EventCoverImage(url: profile.bannerUrl ?? ''),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        colors.darkBlue.withValues(alpha: 0.9),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 16.w,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: colors.darkBlue,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: SizedBox(
                  width: avatarSize.w,
                  height: avatarSize.w,
                  child: EventCoverImage(url: profile.avatarUrl ?? ''),
                ),
              ),
            ),
          ),
          if (data.canFollow)
            Positioned(
              right: 16.w,
              bottom: 4.h,
              child: FollowButton(
                isFollowing: data.isFollowing,
                onPressed: context.read<OrganizerProfileCubit>().toggleFollow,
                width: 140.w,
                height: 48.h,
              ),
            ),
        ],
      ),
    );
  }
}
