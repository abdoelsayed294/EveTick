import 'package:evetick/core/helpers/date_formatter.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/features/home/data/models/home_event_model.dart';
import 'package:evetick/features/home/ui/widgets/event_cover_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PopularEventTile extends StatelessWidget {
  const PopularEventTile({
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
    final place = event.placeText;
    final price = event.priceText;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: context.colors.lightBlue,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: SizedBox(
                width: 84.w,
                height: 84.w,
                child: EventCoverImage(url: event.coverImageUrl),
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
                      color: context.colors.white,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    formatShortDateTime(event.startAt),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12.sp, color: context.colors.lightGray),
                  ),
                  if (place.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Text(
                      place,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12.sp, color: context.colors.lightGray),
                    ),
                  ],
                  if (price.isNotEmpty) ...[
                    SizedBox(height: 6.h),
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: event.isSoldOut
                            ? ColorsManager.gray3
                            : ColorsManager.orange,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: IconButton(
                onPressed: onFavoriteTap,
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? ColorsManager.orange : ColorsManager.lightGray,
                  size: 24.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
