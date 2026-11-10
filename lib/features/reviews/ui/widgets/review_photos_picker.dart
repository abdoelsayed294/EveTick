import 'dart:io';

import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/features/reviews/data/reviews_repository.dart';
import 'package:evetick/features/reviews/logic/write_review_cubit/write_review_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:evetick/features/reviews/ui/widgets/review_upload_tile.dart';
import 'package:evetick/features/reviews/ui/widgets/review_photo_thumbnail.dart';

class ReviewPhotosPicker extends StatelessWidget {
  const ReviewPhotosPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WriteReviewCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.reviewsAddPhotos,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: context.colors.white,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.reviewsOptional,
              style: TextStyle(fontSize: 14.sp, color: context.colors.lightGray),
            ),
          ],
        ),
        verticalSpace(12),
        ValueListenableBuilder<List<File>>(
          valueListenable: cubit.photos,
          builder: (context, photos, _) {
            return SizedBox(
              height: 96.w,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  if (photos.length < ReviewsRepository.maxPhotos) ...[
                    ReviewUploadTile(onTap: cubit.pickPhoto),
                    horizontalSpace(12),
                  ],
                  for (final file in photos) ...[
                    ReviewPhotoThumbnail(file: file, onRemove: () => cubit.removePhoto(file)),
                    horizontalSpace(12),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
