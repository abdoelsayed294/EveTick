import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewPhotoThumbnail extends StatelessWidget {
  const ReviewPhotoThumbnail({super.key, required this.file, required this.onRemove});

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
