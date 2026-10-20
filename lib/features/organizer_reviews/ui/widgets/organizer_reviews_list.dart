import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/widgets/app_empty_view.dart';
import 'package:evetick/features/organizer_reviews/data/models/organizer_reviews_data_model.dart';
import 'package:evetick/features/organizer_reviews/logic/organizer_reviews_cubit.dart';
import 'package:evetick/features/organizer_reviews/ui/widgets/organizer_review_card.dart';
import 'package:evetick/features/reviews/ui/widgets/load_more_reviews.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrganizerReviewsList extends StatelessWidget {
  const OrganizerReviewsList({super.key, required this.data});

  final OrganizerReviewsData data;

  @override
  Widget build(BuildContext context) {
    if (data.reviews.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: const AppEmptyView(message: 'No reviews yet'),
      );
    }

    return Column(
      children: [
        for (final review in data.reviews) ...[
          OrganizerReviewCard(review: review),
          verticalSpace(16),
        ],
        if (data.hasMore)
          Center(
            child: LoadMoreReviews(
              isLoading: data.isLoadingMore,
              error: data.loadMoreError,
              onTap: context.read<OrganizerReviewsCubit>().loadMore,
            ),
          ),
      ],
    );
  }
}
