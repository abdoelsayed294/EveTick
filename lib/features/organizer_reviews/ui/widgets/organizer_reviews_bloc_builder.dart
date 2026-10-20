import 'package:evetick/core/widgets/app_error_view.dart';
import 'package:evetick/features/organizer_reviews/data/models/organizer_reviews_data_model.dart';
import 'package:evetick/features/organizer_reviews/logic/organizer_reviews_cubit.dart';
import 'package:evetick/features/organizer_reviews/ui/widgets/organizer_reviews_content.dart';
import 'package:evetick/features/reviews/logic/reviews_cubit/reviews_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrganizerReviewsBlocBuilder extends StatelessWidget {
  const OrganizerReviewsBlocBuilder({super.key, required this.organizerId});

  final String organizerId;

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
                    organizerId: organizerId,
                    force: true,
                  ),
            ),
          ),
          success: (data) => OrganizerReviewsContent(
            data: data,
            organizerId: organizerId,
          ),
        );
      },
    );
  }
}
