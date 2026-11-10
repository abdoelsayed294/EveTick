import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/features/organizer_reviews/logic/write_organizer_review_cubit.dart';
import 'package:evetick/features/reviews/logic/write_review_cubit/write_review_cubit.dart';
import 'package:evetick/features/organizer_reviews/ui/widgets/post_organizer_review_button.dart';
import 'package:evetick/features/reviews/ui/widgets/anonymous_switch.dart';
import 'package:evetick/features/reviews/ui/widgets/review_text_field.dart';
import 'package:evetick/features/reviews/ui/widgets/star_rating_input.dart';
import 'package:evetick/features/reviews/ui/widgets/write_review_bloc_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WriteOrganizerReviewScreen extends StatelessWidget {
  const WriteOrganizerReviewScreen({super.key, required this.organizerId});

  final String organizerId;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WriteReviewCubit>() as WriteOrganizerReviewCubit;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leadingWidth: 88.w,
          leading: Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(fontSize: 16.sp, color: context.colors.lightGray),
              ),
            ),
          ),
          title: Text(
            'Write a Review',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: context.colors.white,
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: PostOrganizerReviewButton(organizerId: organizerId),
            ),
          ],
        ),
        body: Form(
          key: cubit.formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 32.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const WriteReviewBlocListener(),
                const StarRatingInput(),
                verticalSpace(24),
                Text(
                  'Review',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: context.colors.white,
                  ),
                ),
                verticalSpace(12),
                const ReviewTextField(),
                verticalSpace(24),
                const AnonymousSwitch(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
