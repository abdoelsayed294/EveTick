import 'package:evetick/core/services/toast/app_toast.dart';
import 'package:evetick/core/helpers/extentions.dart';
import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/routing/routes.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/widgets/app_empty_view.dart';
import 'package:evetick/core/widgets/app_error_view.dart';
import 'package:evetick/core/widgets/filled_app_text_button.dart';
import 'package:evetick/features/organizer_reviews/data/models/organizer_review_eligibility_model.dart';
import 'package:evetick/features/organizer_reviews/data/models/organizer_reviews_data_model.dart';
import 'package:evetick/features/organizer_reviews/logic/organizer_reviews_cubit.dart';
import 'package:evetick/features/organizer_reviews/ui/widgets/organizer_review_card.dart';
import 'package:evetick/features/reviews/logic/reviews_cubit/reviews_state.dart';
import 'package:evetick/features/reviews/ui/widgets/load_more_reviews.dart';
import 'package:evetick/features/reviews/ui/widgets/rating_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// "Reviews" tab of the organizer page: average + bars, "Write a Review",
/// the reviews and "Load More Reviews". Loaded the first time the tab opens.
class OrganizerReviewsTab extends StatefulWidget {
  const OrganizerReviewsTab({super.key, required this.organizerId});

  final String organizerId;

  @override
  State<OrganizerReviewsTab> createState() => _OrganizerReviewsTabState();
}

class _OrganizerReviewsTabState extends State<OrganizerReviewsTab> {
  @override
  void initState() {
    super.initState();
    // Does nothing when this organizer was already loaded.
    context.read<OrganizerReviewsCubit>().load(organizerId: widget.organizerId);
  }

  void _showMessage(String message) {
    AppToast.error(message);
  }

  Future<void> _writeReview(OrganizerReviewsData data) async {
    if (data.eligibility != OrganizerReviewEligibility.allowed) {
      _showMessage(data.eligibility.message);
      return;
    }
    final posted = await context.pushNamed(
      Routes.writeOrganizerReviewScreen,
      arguments: widget.organizerId,
    );
    if (posted == true && mounted) {
      // Show the new review and the new average.
      await context.read<OrganizerReviewsCubit>().load(
            organizerId: widget.organizerId,
            silent: true,
            force: true,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrganizerReviewsCubit,
        ReviewsState<OrganizerReviewsData>>(
      builder: (context, state) {
        return state.when(
          initial: () => const SizedBox.shrink(),
          loading: () => Padding(
            padding: EdgeInsets.only(top: 40.h),
            child: const Center(child: CircularProgressIndicator()),
          ),
          error: (error) => Padding(
            padding: EdgeInsets.only(top: 24.h),
            child: AppErrorView(
              message: error,
              onRetry: () => context.read<OrganizerReviewsCubit>().load(
                    organizerId: widget.organizerId,
                    force: true,
                  ),
            ),
          ),
          success: _buildContent,
        );
      },
    );
  }

  Widget _buildContent(OrganizerReviewsData data) {
    final cubit = context.read<OrganizerReviewsCubit>();
    final canWrite = data.eligibility == OrganizerReviewEligibility.allowed;
    final isOwnAccount =
        data.eligibility == OrganizerReviewEligibility.isOrganizer;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RatingSummary(summary: data.summary),
        // Nothing to write on your own organizer account.
        if (!isOwnAccount) ...[
          verticalSpace(24),
          FilledAppTextButton(
            buttonText: canWrite ? 'Write a Review' : _lockedLabel(data),
            buttonWidth: double.infinity,
            backgroundColor: canWrite ? null : ColorsManager.gray3,
            onPressed: () => _writeReview(data),
          ),
        ],
        verticalSpace(24),
        if (data.reviews.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: const AppEmptyView(message: 'No reviews yet'),
          )
        else ...[
          for (final review in data.reviews) ...[
            OrganizerReviewCard(review: review),
            verticalSpace(16),
          ],
          if (data.hasMore)
            Center(
              child: LoadMoreReviews(
                isLoading: data.isLoadingMore,
                error: data.loadMoreError,
                onTap: cubit.loadMore,
              ),
            ),
        ],
      ],
    );
  }

  String _lockedLabel(OrganizerReviewsData data) {
    return data.eligibility == OrganizerReviewEligibility.alreadyReviewed
        ? 'You reviewed this organizer'
        : 'Write a Review';
  }
}
