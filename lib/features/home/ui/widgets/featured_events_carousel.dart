import 'package:evetick/features/home/data/models/home_event_model.dart';
import 'package:evetick/features/home/ui/widgets/featured_event_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeaturedEventsCarousel extends StatelessWidget {
  const FeaturedEventsCarousel({
    super.key,
    required this.events,
    required this.badges,
    required this.onBook,
  });

  final List<HomeEvent> events;
  final Map<String, String> badges;
  final ValueChanged<HomeEvent> onBook;

  @override
  Widget build(BuildContext context) {
    // The next card peeks in from the right, like the design.
    final cardWidth = MediaQuery.sizeOf(context).width - 56.w;

    return SizedBox(
      height: 356.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: events.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (context, index) => SizedBox(
          width: cardWidth,
          child: FeaturedEventCard(
            event: events[index],
            badge: badges[events[index].id],
            onBook: () => onBook(events[index]),
          ),
        ),
      ),
    );
  }
}
