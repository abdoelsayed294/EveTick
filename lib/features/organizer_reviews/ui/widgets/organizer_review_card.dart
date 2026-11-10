import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/helpers/time_ago_formatter.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/features/organizer_reviews/data/models/organizer_review_model.dart';
import 'package:evetick/features/organizer_reviews/ui/widgets/organizer_review_avatar.dart';
import 'package:evetick/features/reviews/ui/widgets/star_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrganizerReviewCard extends StatelessWidget {
  const OrganizerReviewCard({super.key, required this.review});

  final OrganizerReview review;

  @override
  Widget build(BuildContext context) {
    final subtitle = [
      if (review.verified) 'Verified Attendee',
      formatTimeAgo(review.createdAt),
    ].join('  •  ');

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: context.colors.lightBlue,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OrganizerReviewAvatar(url: review.authorImageUrl),
              horizontalSpace(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.authorName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: context.colors.white,
                      ),
                    ),
                    verticalSpace(2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: context.colors.lightGray,
                      ),
                    ),
                  ],
                ),
              ),
              horizontalSpace(8),
              Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: StarRow(rating: review.rating, size: 14),
              ),
            ],
          ),
          if (review.text.trim().isNotEmpty) ...[
            verticalSpace(12),
            Text(
              review.text,
              style: TextStyle(
                fontSize: 14.sp,
                height: 1.45,
                color: context.colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
