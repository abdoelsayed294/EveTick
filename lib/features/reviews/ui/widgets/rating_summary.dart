import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/features/reviews/data/models/review_summary_model.dart';
import 'package:evetick/features/reviews/ui/widgets/star_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:evetick/features/reviews/ui/widgets/rating_star_bar.dart';

class RatingSummary extends StatelessWidget {
  const RatingSummary({super.key, required this.summary});

  final ReviewSummary summary;

  @override
  Widget build(BuildContext context) {
    final total = summary.total;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              summary.averageText,
              style: TextStyle(
                fontSize: 56.sp,
                height: 1.1,
                fontWeight: FontWeight.w800,
                color: ColorsManager.orange,
              ),
            ),
            verticalSpace(4),
            StarRow(rating: summary.roundedAverage, size: 22),
            verticalSpace(8),
            Text(
              AppLocalizations.of(context)!.reviewsReviewsCountTotal(
                NumberFormat('#,###', Localizations.localeOf(context).toString())
                    .format(total),
              ),
              style: TextStyle(fontSize: 16.sp, color: context.colors.lightGray),
            ),
          ],
        ),
        horizontalSpace(24),
        Expanded(
          child: Column(
            children: [
              for (var star = 5; star >= 1; star--) ...[
                RatingStarBar(star: star, fraction: summary.fraction(star)),
                if (star > 1) verticalSpace(10),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
