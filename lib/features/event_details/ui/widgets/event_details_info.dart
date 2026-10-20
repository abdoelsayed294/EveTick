import 'package:evetick/core/helpers/date_formatter.dart';
import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/routing/routes.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/features/event_details/logic/event_details_cubit.dart';
import 'package:evetick/features/event_details/logic/event_details_data.dart';
import 'package:evetick/features/event_details/ui/widgets/event_info_tile.dart';
import 'package:evetick/features/event_details/ui/widgets/event_map_preview.dart';
import 'package:evetick/features/event_details/ui/widgets/expandable_description.dart';
import 'package:evetick/features/event_details/ui/widgets/high_demand_badge.dart';
import 'package:evetick/features/event_details/ui/widgets/organizer_card.dart';
import 'package:evetick/features/reviews/data/models/reviews_args_model.dart';
import 'package:evetick/features/reviews/ui/widgets/reviews_entry_tile.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventDetailsInfo extends StatelessWidget {
  const EventDetailsInfo({
    super.key,
    required this.data,
    required this.eventId,
    required this.mapKey,
    required this.onViewMap,
  });

  final EventDetailsData data;
  final String eventId;
  final GlobalKey mapKey;
  final VoidCallback onViewMap;

  Future<void> _openOrganizer(BuildContext context) async {
    final cubit = context.read<EventDetailsCubit>();
    await Navigator.of(context).pushNamed(
      Routes.organizerProfileScreen,
      arguments: data.event.organizerId,
    );
    cubit.refreshOrganizer();
  }

  void _openReviews(BuildContext context) {
    Navigator.of(context).pushNamed(
      Routes.reviewsScreen,
      arguments: ReviewsArgs(eventId: eventId, eventTitle: data.event.title),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final event = data.event;
    final organizer = event.organizer;
    final place = event.placeText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (event.isHighDemand) ...[
          const HighDemandBadge(),
          verticalSpace(12),
        ],
        Text(event.title, style: TextStyles.font24WhiteBold(context)),
        verticalSpace(16),
        EventInfoTile(
          icon: Icons.calendar_month_outlined,
          title: formatDayAndDate(event.startAt),
          subtitle: formatTimeRange12(event.startAt, event.endAt),
        ),
        if (place.isNotEmpty) ...[
          verticalSpace(16),
          EventInfoTile(
            icon: event.isOnline
                ? Icons.videocam_outlined
                : Icons.location_on_outlined,
            title: place,
            subtitle: event.isOnline ? event.eventUrl : null,
            actionText: event.hasMap ? l10n.eventDetailsViewOnMap : null,
            onAction: event.hasMap ? onViewMap : null,
          ),
        ],
        if (event.description.trim().isNotEmpty) ...[
          verticalSpace(24),
          Text(l10n.eventDetailsDescriptionTitle, style: TextStyles.font18WhiteBold(context)),
          verticalSpace(12),
          ExpandableDescription(text: event.description),
        ],
        if (organizer != null) ...[
          verticalSpace(24),
          Text(l10n.eventDetailsOrganizer, style: TextStyles.font18WhiteBold(context)),
          verticalSpace(12),
          OrganizerCard(
            organizer: organizer,
            isFollowing: data.isFollowing,
            onFollow: context.read<EventDetailsCubit>().toggleFollow,
            onTap: event.organizerId == null
                ? null
                : () => _openOrganizer(context),
          ),
        ],
        verticalSpace(24),
        ReviewsEntryTile(onTap: () => _openReviews(context)),
        if (event.hasMap) ...[
          verticalSpace(24),
          KeyedSubtree(
            key: mapKey,
            child: EventMapPreview(
              coordinates: data.coordinates,
              title: event.title,
            ),
          ),
        ],
        verticalSpace(24),
      ],
    );
  }
}
