import 'package:evetick/core/widgets/app_empty_view.dart';
import 'package:evetick/features/home/data/models/home_event_model.dart';
import 'package:evetick/features/search/ui/widgets/compact_result_tile.dart';
import 'package:evetick/features/search/ui/widgets/featured_result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Column of results: the first one is big, the rest are compact.
/// Meant to be placed inside a scroll view.
class SearchResultsList extends StatelessWidget {
  const SearchResultsList({
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
    if (events.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 80.h),
        child: const AppEmptyView(message: 'No events match your search'),
      );
    }

    return Column(
      children: [
        for (var i = 0; i < events.length; i++) ...[
          if (i > 0) SizedBox(height: 16.h),
          if (i == 0)
            FeaturedResultCard(
              event: events[i],
              isFavorite: favoriteIds.contains(events[i].id),
              onTap: () => onEventTap(events[i]),
              onFavoriteTap: () => onFavoriteTap(events[i]),
            )
          else
            CompactResultTile(
              event: events[i],
              isFavorite: favoriteIds.contains(events[i].id),
              onTap: () => onEventTap(events[i]),
              onFavoriteTap: () => onFavoriteTap(events[i]),
            ),
        ],
      ],
    );
  }
}
