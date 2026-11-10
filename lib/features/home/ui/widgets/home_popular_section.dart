import 'package:evetick/features/home/data/models/home_event_model.dart';
import 'package:evetick/features/home/ui/widgets/popular_event_tile.dart';
import 'package:evetick/features/home/ui/widgets/section_header.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePopularSection extends StatelessWidget {
  const HomePopularSection({
    super.key,
    required this.events,
    required this.favoriteIds,
    required this.onEventTap,
    required this.onFavoriteTap,
  });

  final List<HomeEvent> events;
  final Set<String> favoriteIds;
  final ValueChanged<HomeEvent> onEventTap;
  final ValueChanged<HomeEvent> onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: SectionHeader(
              title: AppLocalizations.of(context)!.homePopularEvents,
            ),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: 16.h)),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 120.h),
          sliver: SliverList.separated(
            itemCount: events.length,
            separatorBuilder: (_, __) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              final event = events[index];
              return PopularEventTile(
                event: event,
                isFavorite: favoriteIds.contains(event.id),
                onTap: () => onEventTap(event),
                onFavoriteTap: () => onFavoriteTap(event),
              );
            },
          ),
        ),
      ],
    );
  }
}
