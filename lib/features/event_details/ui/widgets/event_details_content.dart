import 'package:evetick/core/helpers/date_formatter.dart';
import 'package:evetick/core/services/toast/app_toast.dart';
import 'package:evetick/features/event_details/data/models/event_details_model.dart';
import 'package:evetick/features/event_details/logic/event_details_cubit.dart';
import 'package:evetick/features/event_details/logic/event_details_data.dart';
import 'package:evetick/features/event_details/ui/widgets/event_details_bottom_bar.dart';
import 'package:evetick/features/event_details/ui/widgets/event_details_info.dart';
import 'package:evetick/features/event_details/ui/widgets/event_details_sheet.dart';
import 'package:evetick/features/event_details/ui/widgets/event_header.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EventDetailsContent extends StatefulWidget {
  const EventDetailsContent({
    super.key,
    required this.data,
    required this.eventId,
    required this.onBook,
  });

  final EventDetailsData data;
  final String eventId;
  final VoidCallback onBook;

  @override
  State<EventDetailsContent> createState() => _EventDetailsContentState();
}

class _EventDetailsContentState extends State<EventDetailsContent> {
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
    AppToast.success(AppLocalizations.of(context)!.eventDetailsCopied);
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final event = data.event;
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
                      isFavorite: data.isFavorite,
                      onBack: () => Navigator.of(context).maybePop(),
                      onFavorite: context.read<EventDetailsCubit>().toggleFavorite,
                      onShare: () => _share(event),
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(height: headerHeight - 24.h),
                      EventDetailsSheet(
                        child: EventDetailsInfo(
                          data: data,
                          eventId: widget.eventId,
                          mapKey: _mapKey,
                          onViewMap: _scrollToMap,
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
