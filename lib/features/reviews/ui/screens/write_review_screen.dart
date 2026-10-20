import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/features/reviews/logic/write_review_cubit/write_review_cubit.dart';
import 'package:evetick/features/reviews/logic/write_review_cubit/write_review_state.dart';
import 'package:evetick/features/reviews/ui/widgets/anonymous_switch.dart';
import 'package:evetick/features/reviews/ui/widgets/review_photos_picker.dart';
import 'package:evetick/features/reviews/ui/widgets/review_text_field.dart';
import 'package:evetick/features/reviews/ui/widgets/star_rating_input.dart';
import 'package:evetick/features/reviews/ui/widgets/write_review_bloc_listener.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WriteReviewScreen extends StatelessWidget {
  const WriteReviewScreen({super.key, required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WriteReviewCubit>();
    final l10n = AppLocalizations.of(context)!;

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
                l10n.commonCancel,
                style: TextStyle(fontSize: 16.sp, color: context.colors.lightGray),
              ),
            ),
          ),
          title: Text(
            l10n.reviewsWriteAReview,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: context.colors.white,
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: BlocBuilder<WriteReviewCubit, WriteReviewState<String>>(
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
                        : () => cubit.emitWriteReviewStates(eventId: eventId),
                    child: isLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(l10n.commonPost, style: TextStyles.font16WhiteMidium),
                  );
                },
              ),
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
                  l10n.reviewsReviewLabel,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: context.colors.white,
                  ),
                ),
                verticalSpace(12),
                const ReviewTextField(),
                verticalSpace(24),
                const ReviewPhotosPicker(),
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
