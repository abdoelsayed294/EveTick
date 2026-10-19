import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/features/reviews/data/models/review_summary_model.dart';
import 'package:evetick/features/reviews/ui/widgets/star_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

/// Big average, stars, review count and the 5..1 bars.
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
              '${NumberFormat('#,###').format(total)} ${total == 1 ? 'Review' : 'Reviews'}',
              style: TextStyle(fontSize: 16.sp, color: context.colors.lightGray),
            ),
          ],
        ),
        horizontalSpace(24),
        Expanded(
          child: Column(
            children: [
              for (var star = 5; star >= 1; star--) ...[
                _StarBar(star: star, fraction: summary.fraction(star)),
                if (star > 1) verticalSpace(10),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _StarBar extends StatelessWidget {
  const _StarBar({required this.star, required this.fraction});

  final int star;
  final double fraction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 16.w,
          child: Text(
            '$star',
            style: TextStyle(fontSize: 14.sp, color: context.colors.white),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: LinearProgressIndicator(
              value: fraction,
              minHeight: 8.h,
              color: ColorsManager.orange,
              backgroundColor: context.colors.thirdBlue,
            ),
          ),
        ),
      ],
    );
  }
}
