import 'package:evetick/core/helpers/date_formatter.dart';
import 'package:evetick/core/helpers/order_id_formatter.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/widgets/dashed_line.dart';
import 'package:evetick/features/home/ui/widgets/event_cover_image.dart';
import 'package:evetick/features/my_tickets/data/models/my_ticket_model.dart';
import 'package:evetick/features/my_tickets/ui/widgets/ticket_qr_button.dart';
import 'package:evetick/features/my_tickets/ui/widgets/ticket_status_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evetick/l10n/app_localizations.dart';

class MyTicketCard extends StatelessWidget {
  const MyTicketCard({super.key, required this.ticket, required this.onTap});

  final MyTicket ticket;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final now = DateTime.now();
    final isPast = ticket.phase(now) == TicketPhase.past;
    final place = ticket.location?.trim() ?? '';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: colors.lightBlue,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: SizedBox(
                    width: 64.w,
                    height: 64.w,
                    child: EventCoverImage(url: ticket.coverImageUrl),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TicketStatusBadge(
                        label: ticket.statusLabel(now),
                        isSolid: isPast,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        ticket.eventTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: colors.white,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${formatEventDate(ticket.startAt)}  •  ${formatEventTime(ticket.startAt)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: colors.lightGray,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                TicketQrButton(isPast: isPast, onTap: onTap),
              ],
            ),
            SizedBox(height: 12.h),
            DashedLine(color: colors.lightGray.withValues(alpha: 0.4)),
            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(Icons.location_on, size: 18.sp, color: colors.lightGray),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    place.isEmpty ? AppLocalizations.of(context)!.myTicketsOnlineEvent : place,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12.sp, color: colors.lightGray),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  AppLocalizations.of(context)!.myTicketsTicketIdLabel(formatOrderId(ticket.orderId)),
                  style: TextStyle(fontSize: 12.sp, color: colors.lightGray),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
