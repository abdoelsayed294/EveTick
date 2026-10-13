import 'package:evetick/core/helpers/date_formatter.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/features/home/data/models/home_event_model.dart';
import 'package:evetick/features/home/ui/widgets/event_cover_image.dart';
import 'package:evetick/features/search/ui/widgets/result_favorite_icon.dart';
import 'package:evetick/features/search/ui/widgets/result_info_row.dart';
import 'package:evetick/features/search/ui/widgets/sold_out_tag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Every result after the first one.
class CompactResultTile extends StatelessWidget {
  const CompactResultTile({
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
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: colors.lightBlue,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: SizedBox(
                width: 110.w,
                height: 110.w,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    EventCoverImage(url: event.coverImageUrl),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: ResultFavoriteIcon(
                        isFavorite: isFavorite,
                        onTap: onFavoriteTap,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.white,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  ResultInfoRow(
                    icon: Icons.calendar_month_outlined,
                    text: formatShortDateTime(event.startAt),
                  ),
                  if (place.isNotEmpty) ...[
                    SizedBox(height: 8.h),
                    ResultInfoRow(icon: Icons.location_on, text: place),
                  ],
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          event.startingPriceText,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: ColorsManager.orange,
                          ),
                        ),
                      ),
                      if (event.isSoldOut) const SoldOutTag(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
