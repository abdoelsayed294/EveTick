import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/features/organizer_reviews/data/models/organizer_review_eligibility_model.dart';
import 'package:evetick/features/organizer_reviews/data/models/organizer_reviews_data_model.dart';
import 'package:evetick/features/organizer_reviews/ui/widgets/organizer_reviews_list.dart';
import 'package:evetick/features/organizer_reviews/ui/widgets/write_organizer_review_button.dart';
import 'package:evetick/features/reviews/ui/widgets/rating_summary.dart';
import 'package:flutter/material.dart';

class OrganizerReviewsContent extends StatelessWidget {
  const OrganizerReviewsContent({
    super.key,
    required this.data,
    required this.organizerId,
  });

  final OrganizerReviewsData data;
  final String organizerId;

  @override
  Widget build(BuildContext context) {
    final isOwnAccount =
        data.eligibility == OrganizerReviewEligibility.isOrganizer;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RatingSummary(summary: data.summary),
        if (!isOwnAccount) ...[
          verticalSpace(24),
          WriteOrganizerReviewButton(data: data, organizerId: organizerId),
        ],
        verticalSpace(24),
        OrganizerReviewsList(data: data),
      ],
    );
  }
}
