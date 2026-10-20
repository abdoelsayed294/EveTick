import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/features/reviews/logic/write_review_cubit/write_review_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// "HOW WAS YOUR EXPERIENCE?" + five tappable stars.
class StarRatingInput extends StatelessWidget {
  const StarRatingInput({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WriteReviewCubit>();

    return Column(
      children: [
        Text(
          'HOW WAS YOUR EXPERIENCE?',
          style: TextStyle(
            fontSize: 14.sp,
            letterSpacing: 0.5,
            color: context.colors.lightGray,
          ),
        ),
        verticalSpace(16),
        ValueListenableBuilder<int>(
          valueListenable: cubit.rating,
          builder: (context, rating, _) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final filled = index < rating;
                return GestureDetector(
                  onTap: () => cubit.setRating(index + 1),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Icon(
                      Icons.star_rounded,
                      size: 40.sp,
                      color: filled
                          ? ColorsManager.orange
                          : context.colors.darkGray,
                    ),
                  ),
                );
              }),
            );
          },
        ),
        ValueListenableBuilder<bool>(
          valueListenable: cubit.showRatingError,
          builder: (context, show, _) {
            if (!show) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Text(
                'Please select a rating',
                style: TextStyle(color: ColorsManager.red, fontSize: 14.sp),
              ),
            );
          },
        ),
      ],
    );
  }
}
