import 'package:evetick/core/helpers/extentions.dart';
import 'package:evetick/core/routing/routes.dart';
import 'package:evetick/core/services/toast/app_toast.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/widgets/filled_app_text_button.dart';
import 'package:evetick/features/organizer_reviews/data/models/organizer_review_eligibility_model.dart';
import 'package:evetick/features/organizer_reviews/data/models/organizer_reviews_data_model.dart';
import 'package:evetick/features/organizer_reviews/logic/organizer_reviews_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WriteOrganizerReviewButton extends StatelessWidget {
  const WriteOrganizerReviewButton({
    super.key,
    required this.data,
    required this.organizerId,
  });

  final OrganizerReviewsData data;
  final String organizerId;

  bool get _canWrite => data.eligibility == OrganizerReviewEligibility.allowed;

  String get _label {
    if (_canWrite) return 'Write a Review';
    return data.eligibility == OrganizerReviewEligibility.alreadyReviewed
        ? 'You reviewed this organizer'
        : 'Write a Review';
  }

  Future<void> _writeReview(BuildContext context) async {
    if (!_canWrite) {
      AppToast.error(data.eligibility.message);
      return;
    }
    final cubit = context.read<OrganizerReviewsCubit>();
    final posted = await context.pushNamed(
      Routes.writeOrganizerReviewScreen,
      arguments: organizerId,
    );
    if (posted == true) {
      await cubit.load(organizerId: organizerId, silent: true, force: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FilledAppTextButton(
      buttonText: _label,
      buttonWidth: double.infinity,
      backgroundColor: _canWrite ? null : ColorsManager.gray3,
      onPressed: () => _writeReview(context),
    );
  }
}
