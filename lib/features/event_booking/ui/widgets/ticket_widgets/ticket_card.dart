import 'package:evetick/core/helpers/date_formatter.dart';
import 'package:evetick/core/helpers/order_id_formatter.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/features/event_booking/data/models/ticket_model.dart';
import 'package:evetick/features/event_booking/ui/widgets/ticket_widgets/ticket_divider.dart';
import 'package:evetick/features/event_booking/ui/widgets/ticket_widgets/ticket_info_item.dart';
import 'package:evetick/features/event_booking/ui/widgets/ticket_widgets/ticket_qr_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TicketCard extends StatelessWidget {
  const TicketCard({
    super.key,
    required this.ticket,
    required this.backgroundColor,
  });

  final TicketModel ticket;

  /// Screen background, used for the notches of the divider.
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final hasLocation =
        ticket.eventLocation != null && ticket.eventLocation!.trim().isNotEmpty;
    final hasCategory =
        ticket.eventCategory != null && ticket.eventCategory!.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorsManager.white,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        children: [
          // ---------------- top part
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: ColorsManager.lightGray,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    ticket.statusText,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: ColorsManager.orange,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  ticket.eventTitle,
                  style: TextStyle(
                    fontSize: 24.sp,
                    height: 1.2,
                    fontWeight: FontWeight.w800,
                    color: ColorsManager.darkBlue,
                  ),
                ),
                if (hasCategory) ...[
                  SizedBox(height: 8.h),
                  Text(
                    ticket.eventCategory!,
                    style: TextStyle(fontSize: 16.sp, color: ColorsManager.darkGray),
                  ),
                ],
                SizedBox(height: 24.h),
                Row(
                  children: [
                    Expanded(
                      child: TicketInfoItem(
                        label: 'Date',
                        value: formatEventDate(ticket.eventStartAt),
                      ),
                    ),
                    Expanded(
                      child: TicketInfoItem(
                        label: 'Time',
                        value: formatTimeRange(ticket.eventStartAt, ticket.eventEndAt),
                      ),
                    ),
                  ],
                ),
                if (hasLocation) ...[
                  SizedBox(height: 20.h),
                  TicketInfoItem(label: 'Venue', value: ticket.eventLocation!.trim()),
                ],
                SizedBox(height: 24.h),
                Center(child: TicketQrBox(data: ticket.orderId)),
                SizedBox(height: 12.h),
              ],
            ),
          ),

          TicketDivider(notchColor: backgroundColor),

          // ---------------- bottom part
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
            child: Column(
              children: [
                Text(
                  'SCAN AT ENTRANCE',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: ColorsManager.darkGray,
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TicketInfoItem(
                        label: 'Attendee',
                        value: ticket.attendeeName ?? '-',
                      ),
                    ),
                    Expanded(
                      child: TicketInfoItem(
                        label: ticket.accessLabel,
                        value: ticket.accessText,
                        valueColor: ColorsManager.orange,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TicketInfoItem(
                    label: 'Booking ID',
                    value: formatOrderId(ticket.orderId),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
