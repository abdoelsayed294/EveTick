import 'package:evetick/core/helpers/date_formatter.dart';
import 'package:evetick/core/routing/routes.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/widgets/app_error_view.dart';
import 'package:evetick/features/event_details/data/models/event_details_model.dart';
import 'package:evetick/features/event_details/logic/event_details_cubit.dart';
import 'package:evetick/features/event_details/logic/event_details_state.dart';
import 'package:evetick/features/event_details/ui/widgets/event_details_bottom_bar.dart';
import 'package:evetick/features/event_details/ui/widgets/event_details_info.dart';
import 'package:evetick/features/event_details/ui/widgets/event_details_sheet.dart';
import 'package:evetick/features/event_details/ui/widgets/event_header.dart';
import 'package:evetick/features/reviews/data/models/reviews_args_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Landing page of one event. Receives the event id from the router,
/// "Book Now" opens the booking flow.
class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({
    super.key,
    required this.eventId,
    required this.onBook,
  });

  final String eventId;
  final VoidCallback onBook;

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final _mapKey = GlobalKey();

  void _scrollToMap() {
    final mapContext = _mapKey.currentContext;
    if (mapContext == null) return;
    Scrollable.ensureVisible(
      mapContext,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _share(EventDetails event) async {
    final lines = [
      event.title,
      '${formatDayAndDate(event.startAt)} • ${formatTimeRange12(event.startAt, event.endAt)}',
      if (event.placeText.isNotEmpty) event.placeText,
    ];
    await Clipboard.setData(ClipboardData(text: lines.join('\n')));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Event details copied to clipboard')),
      );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventDetailsCubit, EventDetailsState>(
      builder: (context, state) {
        switch (state.status) {
          case EventDetailsStatus.loading:
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          case EventDetailsStatus.error:
            return Scaffold(
              appBar: AppBar(
                iconTheme: IconThemeData(color: context.colors.white),
              ),
              body: AppErrorView(
                message: state.errorMessage,
                onRetry: () => context
                    .read<EventDetailsCubit>()
                    .getEventDetails(widget.eventId),
              ),
            );
          case EventDetailsStatus.success:
            return _buildContent(context, state, state.event!);
        }
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    EventDetailsState state,
    EventDetails event,
  ) {
    final cubit = context.read<EventDetailsCubit>();
    final headerHeight = 340.h;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  SizedBox(
                    height: headerHeight,
                    width: double.infinity,
                    child: EventHeader(
                      images: event.images,
                      isFavorite: state.isFavorite,
                      onBack: () => Navigator.of(context).maybePop(),
                      onFavorite: cubit.toggleFavorite,
                      onShare: () => _share(event),
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(height: headerHeight - 24.h),
                      EventDetailsSheet(
                        child: EventDetailsInfo(
                          event: event,
                          state: state,
                          mapKey: _mapKey,
                          onViewMap: _scrollToMap,
                          onToggleFollow: cubit.toggleFollow,
                          onOpenOrganizer: () async {
                            await Navigator.of(context).pushNamed(
                              Routes.organizerProfileScreen,
                              arguments: event.organizerId,
                            );
                            // (Un)followed on the organizer page?
                            cubit.refreshOrganizer();
                          },
                          onOpenReviews: () => Navigator.of(context).pushNamed(
                            Routes.reviewsScreen,
                            arguments: ReviewsArgs(
                              eventId: widget.eventId,
                              eventTitle: event.title,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          EventDetailsBottomBar(
            priceText: event.priceText,
            isSoldOut: event.isSoldOut,
            onBook: widget.onBook,
          ),
        ],
      ),
    );
  }
}
