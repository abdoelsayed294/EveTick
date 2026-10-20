import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/helpers/time_ago_formatter.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/features/reviews/data/models/review_model.dart';
import 'package:evetick/features/reviews/ui/widgets/review_photos_row.dart';
import 'package:evetick/features/reviews/ui/widgets/star_row.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({
    super.key,
    required this.review,
    required this.onHelpful,
    required this.onReply,
  });

  final Review review;
  final VoidCallback onHelpful;
  final VoidCallback onReply;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final time = formatTimeAgo(
      review.createdAt,
      locale: Localizations.localeOf(context),
    );
    final subtitle = review.verified
        ? l10n.reviewsVerifiedAttendee(time)
        : time;

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
              _Avatar(url: review.authorImageUrl),
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
          if (review.photoUrls.isNotEmpty) ...[
            verticalSpace(12),
            ReviewPhotosRow(urls: review.photoUrls),
          ],
          verticalSpace(12),
          Row(
            children: [
              _Action(
                icon: review.isHelpful
                    ? Icons.thumb_up_alt_rounded
                    : Icons.thumb_up_alt_outlined,
                label: l10n.reviewsHelpfulCount('${review.helpfulCount}'),
                color: review.isHelpful
                    ? ColorsManager.orange
                    : context.colors.lightGray,
                // Nobody votes for their own review.
                onTap: review.isMine ? null : onHelpful,
              ),
              horizontalSpace(24),
              _Action(
                icon: Icons.chat_bubble_rounded,
                label: l10n.reviewsReply,
                color: context.colors.lightGray,
                onTap: onReply,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      color: context.colors.thirdBlue,
      alignment: Alignment.center,
      child: Icon(Icons.person, color: context.colors.lightGray, size: 26.sp),
    );

    return ClipOval(
      child: SizedBox(
        width: 48.w,
        height: 48.w,
        child: url == null
            ? placeholder
            : Image.network(
                url!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => placeholder,
              ),
      ),
    );
  }
}

class _Action extends StatelessWidget {
  const _Action({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22.sp, color: color),
            horizontalSpace(8),
            Text(label, style: TextStyle(fontSize: 14.sp, color: color)),
          ],
        ),
      ),
    );
  }
}
