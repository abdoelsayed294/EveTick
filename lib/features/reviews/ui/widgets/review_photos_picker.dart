import 'dart:io';

import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/features/help_support/ui/widgets/dashed_border_painter.dart';
import 'package:evetick/features/reviews/data/reviews_repository.dart';
import 'package:evetick/features/reviews/logic/write_review_cubit/write_review_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// "Add Photos (optional)": the UPLOAD tile and the picked thumbnails.
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
              'Add Photos',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: context.colors.white,
              ),
            ),
            Text(
              'optional',
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
                    _UploadTile(onTap: cubit.pickPhoto),
                    horizontalSpace(12),
                  ],
                  for (final file in photos) ...[
                    _Thumbnail(file: file, onRemove: () => cubit.removePhoto(file)),
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

class _UploadTile extends StatelessWidget {
  const _UploadTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedBorderPainter(
        color: context.colors.lightGray,
        radius: 16,
        strokeWidth: 1.5,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: SizedBox(
          width: 96.w,
          height: 96.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_a_photo_outlined, color: context.colors.white, size: 26.sp),
              verticalSpace(6),
              Text(
                'UPLOAD',
                style: TextStyle(fontSize: 12.sp, color: context.colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.file, required this.onRemove});

  final File file;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Image.file(file, width: 96.w, height: 96.w, fit: BoxFit.cover),
        ),
        Positioned(
          top: 6.w,
          right: 6.w,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 22.w,
              height: 22.w,
              decoration: const BoxDecoration(
                color: Colors.black87,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, size: 14.sp, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
