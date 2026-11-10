import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/features/home/data/models/home_event_model.dart';
import 'package:evetick/features/home/ui/widgets/event_cover_image.dart';
import 'package:evetick/features/organizer_profile/ui/widgets/organizer_date_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrganizerEventCard extends StatelessWidget {
  const OrganizerEventCard({super.key, required this.event, required this.onTap});

  final HomeEvent event;
  final VoidCallback onTap;

  String get _priceText {
    final price = event.minPrice;
    if (price == null) return '';
    if (price == 0) return 'Free';
    return '\$${price.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final place = event.placeText;
    final price = _priceText;
    final start = DateTime.tryParse(event.startAt);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: colors.lightBlue,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: SizedBox(
                height: 170.h,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    EventCoverImage(url: event.coverImageUrl),
                    if (start != null)
                      Positioned(
                        top: 10.h,
                        left: 10.w,
                        child: OrganizerDateBadge(date: start),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12.h),
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
            if (place.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16.sp, color: colors.lightGray),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      place,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13.sp, color: colors.lightGray),
                    ),
                  ),
                ],
              ),
            ],
            if (price.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Text(
                price,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: ColorsManager.orange,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
