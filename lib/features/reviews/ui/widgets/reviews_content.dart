import 'package:evetick/core/helpers/extentions.dart';
import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/routing/routes.dart';
import 'package:evetick/core/services/toast/app_toast.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/widgets/app_empty_view.dart';
import 'package:evetick/core/widgets/filled_app_text_button.dart';
import 'package:evetick/features/reviews/data/models/review_eligibility_model.dart';
import 'package:evetick/features/reviews/data/models/reviews_data_model.dart';
import 'package:evetick/features/reviews/logic/reviews_cubit/reviews_cubit.dart';
import 'package:evetick/features/reviews/ui/widgets/load_more_reviews.dart';
import 'package:evetick/features/reviews/ui/widgets/rating_summary.dart';
import 'package:evetick/features/reviews/ui/widgets/review_card.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewsContent extends StatelessWidget {
  const ReviewsContent({
    super.key,
    required this.data,
    required this.eventId,
    required this.onRefresh,
  });

  final ReviewsData data;
  final String eventId;

  final Future<void> Function() onRefresh;

  Future<void> _writeReview(BuildContext context) async {
    if (data.eligibility != ReviewEligibility.allowed) {
      AppToast.error(data.eligibility.message);
      return;
    }
    final posted = await context.pushNamed(
      Routes.writeReviewScreen,
      arguments: eventId,
    );
    if (posted == true && context.mounted) {
      await onRefresh();
    }
  }

  String _lockedLabel(BuildContext context) {
    return data.eligibility == ReviewEligibility.alreadyReviewed
        ? AppLocalizations.of(context)!.reviewsAlreadyReviewed
        : AppLocalizations.of(context)!.reviewsWriteAReview;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<ReviewsCubit>();
    final canWrite = data.eligibility == ReviewEligibility.allowed;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 32.h),
        children: [
          RatingSummary(summary: data.summary),
          verticalSpace(24),
          FilledAppTextButton(
            buttonText: canWrite ? l10n.reviewsWriteAReview : _lockedLabel(context),
            buttonWidth: double.infinity,
            backgroundColor: canWrite ? null : ColorsManager.gray3,
            onPressed: () => _writeReview(context),
          ),
          verticalSpace(24),
          if (data.reviews.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 48.h),
              child: AppEmptyView(message: l10n.reviewsNoReviewsYet),
            )
          else ...[
            for (final review in data.reviews) ...[
              ReviewCard(
                review: review,
                onHelpful: () => cubit.toggleHelpful(review.id),
                onReply: () => AppToast.error(l10n.reviewsRepliesComingSoon),
              ),
              verticalSpace(16),
            ],
            if (data.hasMore)
              LoadMoreReviews(
                isLoading: data.isLoadingMore,
                error: data.loadMoreError,
                onTap: cubit.loadMore,
              ),
          ],
        ],
      ),
    );
  }
}
