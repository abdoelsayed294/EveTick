import 'package:evetick/core/helpers/date_formatter.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/features/favorites/ui/widgets/category_tag.dart';
import 'package:evetick/features/favorites/ui/widgets/favorite_heart_button.dart';
import 'package:evetick/features/favorites/ui/widgets/favorite_info_row.dart';
import 'package:evetick/features/home/data/models/home_event_model.dart';
import 'package:evetick/features/home/ui/widgets/event_cover_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavoriteEventCard extends StatelessWidget {
  const FavoriteEventCard({
    super.key,
    required this.event,
    required this.onTap,
    required this.onRemove,
  });

  final HomeEvent event;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final place = event.placeText;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colors.lightBlue,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: colors.lightGray.withValues(alpha: 0.15)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 190.h,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  EventCoverImage(url: event.coverImageUrl),
                  if (event.category.isNotEmpty)
                    Positioned(
                      left: 16.w,
                      bottom: 12.h,
                      child: CategoryTag(label: event.category),
                    ),
                  Positioned(
                    top: 12.h,
                    right: 12.w,
                    child: FavoriteHeartButton(onTap: onRemove),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.white,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  FavoriteInfoRow(
                    icon: Icons.calendar_month_outlined,
                    text:
                        '${formatEventDate(event.startAt)}  •  ${formatEventTime(event.startAt)}',
                  ),
                  if (place.isNotEmpty) ...[
                    SizedBox(height: 12.h),
                    FavoriteInfoRow(icon: Icons.location_on, text: place),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
