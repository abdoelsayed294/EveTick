import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EventLocationBanner extends StatelessWidget {
  const EventLocationBanner({
    super.key,
    required this.location,
    required this.imageUrl,
  });

  final String location;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final split = location.lastIndexOf(',');
    final venue = split == -1 ? location : location.substring(0, split).trim();
    final city = split == -1 ? null : location.substring(split + 1).trim();

    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: SizedBox(
        width: double.infinity,
        height: 100.h,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: context.colors.thirdBlue),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    ColorsManager.black.withValues(alpha: 0.65),
                  ],
                ),
              ),
            ),
            if (city != null && city.isNotEmpty)
              Positioned(
                top: 8.h,
                right: 8.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: context.colors.thirdBlue,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_on, color: ColorsManager.orange, size: 14.sp),
                      SizedBox(width: 2.w),
                      Text(
                        city,
                        style: TextStyle(
                          color: ColorsManager.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Positioned(
              left: 16.w,
              right: 16.w,
              bottom: 12.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Event Location', style: TextStyles.font16WhiteRegular(context)),
                  Text(
                    venue,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.font16WhiteBold(context),
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
