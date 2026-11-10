import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/features/reviews/logic/write_review_cubit/write_review_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evetick/l10n/app_localizations.dart';

class AnonymousSwitch extends StatelessWidget {
  const AnonymousSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WriteReviewCubit>();

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.reviewsPostAnonymously,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: context.colors.white,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                AppLocalizations.of(context)!.reviewsAnonymousNote,
                style: TextStyle(fontSize: 12.sp, color: context.colors.lightGray),
              ),
            ],
          ),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: cubit.isAnonymous,
          builder: (context, value, _) {
            return Switch(
              value: value,
              onChanged: cubit.setAnonymous,
              thumbColor: const WidgetStatePropertyAll(ColorsManager.darkBlue),
              trackColor: WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.selected)
                    ? ColorsManager.orange
                    : context.colors.thirdBlue,
              ),
              trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
            );
          },
        ),
      ],
    );
  }
}
