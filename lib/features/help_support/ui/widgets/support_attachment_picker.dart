import 'dart:io';

import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/features/help_support/logic/send_message/send_message_cubit.dart';
import 'package:evetick/features/help_support/ui/widgets/dashed_border_painter.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SupportAttachmentPicker extends StatelessWidget {
  const SupportAttachmentPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<SendMessageCubit>();

    return Column(
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            l10n.helpSupportAttachmentsOptional,
            style: TextStyles.font12LightGrayRegular(
              context,
            ).copyWith(color: context.colors.white),
          ),
        ),
        verticalSpace(12),
        ValueListenableBuilder<File?>(
          valueListenable: cubit.attachment,
          builder: (context, attachment, _) {
            final fileName = attachment?.path.split(RegExp(r'[\\/]')).last;

            return CustomPaint(
              painter: DashedBorderPainter(color: context.colors.lightGray),
              child: InkWell(
                borderRadius: BorderRadius.circular(12.r),
                onTap: cubit.pickAttachment,
                child: Container(
                  height: 48.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate,
                        color: context.colors.lightGray,
                        size: 24.sp,
                      ),
                      horizontalSpace(8),
                      Flexible(
                        child: Text(
                          fileName ?? l10n.helpSupportUploadScreenshot,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.font16WhiteRegular(context),
                        ),
                      ),
                      if (fileName != null) ...[
                        horizontalSpace(8),
                        GestureDetector(
                          onTap: cubit.removeAttachment,
                          child: Icon(
                            Icons.close,
                            color: context.colors.lightGray,
                            size: 20.sp,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        verticalSpace(8),
        Text(
          l10n.helpSupportSupportedFormatsNotice,
          style: TextStyles.font12LightGrayRegular(context),
        ),
      ],
    );
  }
}
