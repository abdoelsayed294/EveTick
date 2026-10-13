import 'package:evetick/core/helpers/date_formatter.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/features/home/data/models/home_event_model.dart';
import 'package:evetick/features/home/ui/widgets/event_cover_image.dart';
import 'package:evetick/features/search/ui/widgets/result_favorite_icon.dart';
import 'package:evetick/features/search/ui/widgets/result_info_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// First result: big cover on top, details below.
class FeaturedResultCard extends StatelessWidget {
  const FeaturedResultCard({
    super.key,
    required this.event,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteTap,
  });

  final HomeEvent event;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final place = event.placeText;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colors.lightBlue,
          borderRadius: BorderRadius.circular(16.r),
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
                  Positioned(
                    top: 4.h,
                    right: 4.w,
                    child: ResultFavoriteIcon(
                      isFavorite: isFavorite,
                      onTap: onFavoriteTap,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          event.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        event.startingPriceText,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: ColorsManager.orange,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  ResultInfoRow(
                    icon: Icons.calendar_month_outlined,
                    text: formatShortDateTime(event.startAt),
                  ),
                  if (place.isNotEmpty) ...[
                    SizedBox(height: 12.h),
                    ResultInfoRow(icon: Icons.location_on, text: place),
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
