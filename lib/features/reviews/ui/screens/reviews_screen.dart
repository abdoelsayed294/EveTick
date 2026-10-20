import 'package:evetick/core/services/toast/app_toast.dart';
import 'package:evetick/core/helpers/extentions.dart';
import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/routing/routes.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/core/widgets/app_empty_view.dart';
import 'package:evetick/core/widgets/app_error_view.dart';
import 'package:evetick/core/widgets/filled_app_text_button.dart';
import 'package:evetick/features/reviews/data/models/review_eligibility_model.dart';
import 'package:evetick/features/reviews/data/models/reviews_args_model.dart';
import 'package:evetick/features/reviews/data/models/reviews_data_model.dart';
import 'package:evetick/features/reviews/logic/reviews_cubit/reviews_cubit.dart';
import 'package:evetick/features/reviews/logic/reviews_cubit/reviews_state.dart';
import 'package:evetick/features/reviews/ui/widgets/load_more_reviews.dart';
import 'package:evetick/features/reviews/ui/widgets/rating_summary.dart';
import 'package:evetick/features/reviews/ui/widgets/review_card.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// "Reviews & Rating" of one event.
class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key, required this.args});

  final ReviewsArgs args;

  Future<void> _refresh(BuildContext context, {bool silent = true}) {
    return context.read<ReviewsCubit>().emitReviewsStates(
          eventId: args.eventId,
          silent: silent,
        );
  }

  void _showMessage(BuildContext context, String message) {
    AppToast.error(message);
  }

  Future<void> _writeReview(BuildContext context, ReviewsData data) async {
    if (data.eligibility != ReviewEligibility.allowed) {
      _showMessage(context, data.eligibility.message);
      return;
    }
    final posted = await context.pushNamed(
      Routes.writeReviewScreen,
      arguments: args.eventId,
    );
    if (posted == true && context.mounted) {
      await _refresh(context); // show the new review and the new average
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: context.colors.white),
        title: Text(
          l10n.reviewsTitle,
          style: TextStyles.font18WhiteBold(context),
        ),
      ),
      body: BlocBuilder<ReviewsCubit, ReviewsState<ReviewsData>>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error) => AppErrorView(
              message: error,
              onRetry: () => _refresh(context, silent: false),
            ),
            success: (data) => _buildContent(context, data),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, ReviewsData data) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<ReviewsCubit>();
    final canWrite = data.eligibility == ReviewEligibility.allowed;

    return RefreshIndicator(
      onRefresh: () => _refresh(context),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 32.h),
        children: [
          RatingSummary(summary: data.summary),
          verticalSpace(24),
          FilledAppTextButton(
            buttonText: canWrite ? l10n.reviewsWriteAReview : _lockedLabel(context, data),
            buttonWidth: double.infinity,
            backgroundColor: canWrite ? null : ColorsManager.gray3,
            onPressed: () => _writeReview(context, data),
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
                // TODO: replies need their own screen (no design yet).
                onReply: () => _showMessage(context, l10n.reviewsRepliesComingSoon),
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

  String _lockedLabel(BuildContext context, ReviewsData data) {
    return data.eligibility == ReviewEligibility.alreadyReviewed
        ? AppLocalizations.of(context)!.reviewsAlreadyReviewed
        : AppLocalizations.of(context)!.reviewsWriteAReview;
  }
}
