import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingSummaryCard extends StatelessWidget {
  const BookingSummaryCard({
    super.key,
    required this.ticketLabel,
    required this.eventName,
    required this.date,
    required this.time,
    this.imageUrl,
  });

  final String ticketLabel;
  final String eventName;
  final String date;
  final String time;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.colors.lightBlue,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ticketLabel, style: TextStyles.font12OrangeMid),
                verticalSpace(8),
                Text(
                  eventName,
                  style: TextStyles.font16WhiteMid(context),
                ),
                verticalSpace(8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 16.sp,
                      color: context.colors.lightGray,
                    ),
                    horizontalSpace(8),
                    Text(date, style: TextStyles.font12LightGrayRegular(context)),
                    horizontalSpace(8),
                    Icon(
                      Icons.circle,
                      size: 6.sp,
                      color: context.colors.lightGray,
                    ),
                    horizontalSpace(8),
                    Text(time, style: TextStyles.font12LightGrayRegular(context)),
                  ],
                ),
              ],
            ),
          ),
          horizontalSpace(12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              width: 81.w,
              height: 84.h,
              color: context.colors.thirdBlue,
              alignment: Alignment.center,
              child: imageUrl == null
                  ? Icon(
                      Icons.image_outlined,
                      color: context.colors.darkGray,
                      size: 28.sp,
                    )
                  : Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      width: 81.w,
                      height: 84.h,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}