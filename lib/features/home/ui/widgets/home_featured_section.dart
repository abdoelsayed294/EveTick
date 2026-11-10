import 'package:evetick/features/home/data/models/home_event_model.dart';
import 'package:evetick/features/home/ui/widgets/featured_events_carousel.dart';
import 'package:evetick/features/home/ui/widgets/section_header.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeFeaturedSection extends StatelessWidget {
  const HomeFeaturedSection({
    super.key,
    required this.events,
    required this.badges,
    required this.onEventTap,
  });

  final List<HomeEvent> events;
  final Map<String, String> badges;
  final ValueChanged<HomeEvent> onEventTap;

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SectionHeader(
              title: AppLocalizations.of(context)!.homeFeaturedEvents,
            ),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 16.h)),
        SliverToBoxAdapter(
          child: FeaturedEventsCarousel(
            events: events,
            badges: badges,
            onBook: onEventTap,
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 24.h)),
      ],
    );
  }
}
