import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/features/organizer_reviews/logic/write_organizer_review_cubit.dart';
import 'package:evetick/features/reviews/logic/write_review_cubit/write_review_cubit.dart';
import 'package:evetick/features/reviews/logic/write_review_cubit/write_review_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostOrganizerReviewButton extends StatelessWidget {
  const PostOrganizerReviewButton({super.key, required this.organizerId});

  final String organizerId;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WriteReviewCubit>() as WriteOrganizerReviewCubit;

    return BlocBuilder<WriteReviewCubit, WriteReviewState<String>>(
      builder: (context, state) {
        final isLoading = state is WriteReviewLoading<String>;
        return TextButton(
          style: TextButton.styleFrom(
            backgroundColor: ColorsManager.orange,
            minimumSize: Size(76.w, 44.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          onPressed: isLoading
              ? null
              : () => cubit.postOrganizerReview(organizerId: organizerId),
          child: isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text('Post', style: TextStyles.font16WhiteMidium),
        );
      },
    );
  }
}
