import 'package:evetick/features/event_details/ui/widgets/event_details_bloc_builder.dart';
import 'package:flutter/material.dart';

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({
    super.key,
    required this.eventId,
    required this.onBook,
  });

  final String eventId;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    return EventDetailsBlocBuilder(eventId: eventId, onBook: onBook);
  }
}
