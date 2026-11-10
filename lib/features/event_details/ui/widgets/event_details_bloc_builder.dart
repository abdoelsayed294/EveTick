import 'package:evetick/features/event_details/logic/event_details_cubit.dart';
import 'package:evetick/features/event_details/logic/event_details_data.dart';
import 'package:evetick/features/event_details/logic/event_details_state.dart';
import 'package:evetick/features/event_details/ui/widgets/event_details_content.dart';
import 'package:evetick/features/event_details/ui/widgets/event_details_error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventDetailsBlocBuilder extends StatelessWidget {
  const EventDetailsBlocBuilder({
    super.key,
    required this.eventId,
    required this.onBook,
  });

  final String eventId;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventDetailsCubit, EventDetailsState>(
      buildWhen: (previous, current) =>
          current is Loading || current is Success || current is Error,
      builder: (context, state) {
        return state.maybeWhen(
          success: (data) => EventDetailsContent(
            data: data as EventDetailsData,
            eventId: eventId,
            onBook: onBook,
          ),
          error: (error) => EventDetailsErrorView(
            message: error,
            onRetry: () =>
                context.read<EventDetailsCubit>().getEventDetails(eventId),
          ),
          orElse: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}
