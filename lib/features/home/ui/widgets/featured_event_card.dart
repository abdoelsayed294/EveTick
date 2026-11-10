import 'package:evetick/core/helpers/date_formatter.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/widgets/filled_app_text_button.dart';
import 'package:evetick/features/home/data/models/home_event_model.dart';
import 'package:evetick/features/home/ui/widgets/event_badge.dart';
import 'package:evetick/features/home/ui/widgets/event_cover_image.dart';
import 'package:evetick/features/home/ui/widgets/featured_info_line.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeaturedEventCard extends StatelessWidget {
  const FeaturedEventCard({
    super.key,
    required this.event,
    required this.onBook,
    this.badge,
  });

  final HomeEvent event;
  final VoidCallback onBook;

  final String? badge;

  @override
  Widget build(BuildContext context) {
    final label = badge?.trim() ?? '';
    final place = event.placeText;

    return GestureDetector(
      onTap: onBook,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            EventCoverImage(url: event.coverImageUrl),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.35, 1],
                  colors: [
                    Colors.transparent,
                    ColorsManager.black.withValues(alpha: 0.9),
                  ],
                ),
              ),
            ),
            if (label.isNotEmpty)
              Positioned(
                top: 16.h,
                left: 16.w,
                child: EventBadge(label: label),
              ),
            Positioned(
              left: 16.w,
              right: 16.w,
              bottom: 16.h,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: ColorsManager.white,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  FeaturedInfoLine(
                    icon: Icons.calendar_month_outlined,
                    text: formatShortDateTime(event.startAt),
                  ),
                  if (place.isNotEmpty) ...[
                    SizedBox(height: 8.h),
                    FeaturedInfoLine(icon: Icons.location_on, text: place),
                  ],
                  SizedBox(height: 16.h),
                  FilledAppTextButton(
                    buttonText: event.isSoldOut
                        ? AppLocalizations.of(context)!.commonSoldOut
                        : AppLocalizations.of(context)!.commonBookNow,
                    backgroundColor: event.isSoldOut
                        ? ColorsManager.gray3
                        : null,
                    onPressed: event.isSoldOut ? () {} : onBook,
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
