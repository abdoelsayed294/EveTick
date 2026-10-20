import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/features/reviews/data/reviews_repository.dart';
import 'package:evetick/features/reviews/logic/write_review_cubit/write_review_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewTextField extends StatelessWidget {
  const ReviewTextField({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WriteReviewCubit>();

    return TextFormField(
      controller: cubit.reviewController,
      minLines: 6,
      maxLines: 10,
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      inputFormatters: [
        LengthLimitingTextInputFormatter(ReviewsRepository.maxTextLength),
      ],
      style: TextStyle(color: context.colors.white, fontSize: 16.sp),
      cursorColor: context.colors.white,
      validator: (value) {
        if ((value ?? '').trim().length < ReviewsRepository.minTextLength) {
          return 'Please write at least ${ReviewsRepository.minTextLength} characters';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: 'Share your experience with others…',
        hintStyle: TextStyle(color: context.colors.lightGray, fontSize: 16.sp),
        filled: true,
        fillColor: context.colors.lightBlue,
        contentPadding: EdgeInsets.all(16.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}
