import 'package:evetick/core/routing/routes.dart';
import 'package:evetick/core/widgets/app_empty_view.dart';
import 'package:evetick/features/home/data/models/home_event_model.dart';
import 'package:evetick/features/organizer_profile/ui/widgets/organizer_event_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrganizerEventsList extends StatelessWidget {
  const OrganizerEventsList({
    super.key,
    required this.events,
    required this.emptyMessage,
  });

  final List<HomeEvent> events;
  final String emptyMessage;

  void _openEvent(BuildContext context, HomeEvent event) {
    Navigator.of(context)
        .pushNamed(Routes.eventDetailsScreen, arguments: event.id);
  }

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: 40.h),
        child: AppEmptyView(message: emptyMessage),
      );
    }
    return Column(
      children: [
        for (final event in events) ...[
          OrganizerEventCard(
            event: event,
            onTap: () => _openEvent(context, event),
          ),
          SizedBox(height: 16.h),
        ],
      ],
    );
  }
}
