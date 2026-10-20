import 'package:evetick/core/helpers/count_formatter.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/features/following_organizers/data/models/followed_organizer_model.dart';
import 'package:evetick/features/following_organizers/ui/widgets/follow_button.dart';
import 'package:evetick/features/home/ui/widgets/event_cover_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrganizerTile extends StatelessWidget {
  const OrganizerTile({
    super.key,
    required this.organizer,
    required this.onTap,
    required this.onToggleFollow,
  });

  final FollowedOrganizer organizer;
  final VoidCallback onTap;
  final VoidCallback onToggleFollow;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          children: [
            ClipOval(
              child: SizedBox(
                width: 64.w,
                height: 64.w,
                child: EventCoverImage(url: organizer.avatarUrl ?? ''),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    organizer.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.white,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    followersLabel(organizer.followers),
                    style: TextStyle(fontSize: 13.sp, color: colors.lightGray),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            FollowButton(
              isFollowing: organizer.isFollowing,
              onPressed: onToggleFollow,
            ),
          ],
        ),
      ),
    );
  }
}
