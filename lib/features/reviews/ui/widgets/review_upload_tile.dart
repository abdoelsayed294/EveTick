import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/features/help_support/ui/widgets/dashed_border_painter.dart';
import 'package:evetick/l10n/app_localizations.dart';

class ReviewUploadTile extends StatelessWidget {
  const ReviewUploadTile({super.key, required this.onTap});

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
                AppLocalizations.of(context)!.profileUpload,
                style: TextStyle(fontSize: 12.sp, color: context.colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
