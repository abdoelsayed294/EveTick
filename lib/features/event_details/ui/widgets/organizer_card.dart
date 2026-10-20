import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/widgets/filled_app_text_button.dart';
import 'package:evetick/features/event_details/data/models/event_organizer_model.dart';
import 'package:evetick/features/home/ui/widgets/event_cover_image.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrganizerCard extends StatelessWidget {
  const OrganizerCard({
    super.key,
    required this.organizer,
    required this.isFollowing,
    required this.onFollow,
    this.onTap,
  });

  final EventOrganizer organizer;
  final bool isFollowing;
  final VoidCallback onFollow;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onTap,
      child: Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.colors.lightBlue,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          ClipOval(
            child: SizedBox(
              width: 56.w,
              height: 56.w,
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
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: context.colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  organizer.followers > 0
                      ? l10n.eventDetailsFollowers(organizer.followersText)
                      : l10n.eventDetailsOrganizer,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: context.colors.lightGray,
                  ),
                ),
              ],
            ),
          ),
          FilledAppTextButton(
            buttonText: isFollowing ? l10n.commonFollowing : l10n.commonFollow,
            buttonWidth: 100.w,
            buttonHeight: 40.h,
            backgroundColor: isFollowing ? ColorsManager.gray3 : null,
            onPressed: onFollow,
          ),
        ],
      ),
      ),
    );
  }
}
