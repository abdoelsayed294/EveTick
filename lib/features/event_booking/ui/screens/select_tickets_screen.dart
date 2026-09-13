import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/features/event_booking/ui/widgets/select_tickets_widgets/selected_tickets_bar.dart';
import 'package:evetick/features/event_booking/ui/widgets/select_tickets_widgets/ticket_type_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectTicketsScreen extends StatelessWidget {
  SelectTicketsScreen({super.key, this.onNext});

  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Booking For', style: TextStyles.font16GrayRegular),
                    verticalSpace(4),
                    Text(
                      'Summer Echoes Music Festival',
                      style: TextStyles.font18WhiteBold(context),
                    ),
                    verticalSpace(24),
                    TicketTypeContainer(
                      name: 'Early Brid',
                      description:
                          'Limited quantities for our early supporters. includes standard entry.',
                      price: 35,
                    ),
                    verticalSpace(16),
                    TicketTypeContainer(
                      name: 'General Admission',
                      description:
                          'Limited quantities for our early supporters. includes standard entry.',
                      price: 45,
                    ),
                    verticalSpace(16),
                    TicketTypeContainer(
                      name: 'VIP Access',
                      description:
                          '-Backstage lounge access. \n -2 Complimentary drink vouchers. \n -Premium viewing area.',
                      price: 120,
                    ),
                    verticalSpace(16),
                    TicketTypeContainer(
                      name: 'Backstage Pass',
                      description:
                          'Meet and Greet with performers. includes all VIP perks.',
                      price: 250,
                      isSoldOut: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SelectedTicketsBar(onNext: onNext),
        ],
      ),
    );
  }
}
