import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/features/help_support/data/models/help_category.dart';
import 'package:evetick/features/help_support/logic/send_message/send_message_cubit.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SupportCategoryDropdown extends StatelessWidget {
  const SupportCategoryDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    OutlineInputBorder border(Color color) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: color, width: 1.3),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.helpSupportWhatCanWeHelpWith,
          style: TextStyles.font16WhiteRegular(context),
        ),
        verticalSpace(8),
        ValueListenableBuilder<HelpCategory?>(
          valueListenable: context.read<SendMessageCubit>().category,
          builder: (context, category, _) {
            return DropdownButtonFormField<HelpCategory>(
              value: category,
              isExpanded: true,
              dropdownColor: context.colors.lightBlue,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: context.colors.lightGray,
              ),
              style: TextStyles.font14LightGrayRegular(
                context,
              ).copyWith(color: context.colors.white),
              hint: Text(
                l10n.helpSupportSelectCategory,
                style: TextStyles.font14LightGrayRegular(context),
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: context.colors.lightBlue,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 14.h,
                ),
                enabledBorder: border(context.colors.lightBlue),
                focusedBorder: border(ColorsManager.orange),
                errorBorder: border(ColorsManager.red),
                focusedErrorBorder: border(ColorsManager.red),
              ),
              items: [
                for (final category in HelpCategory.values)
                  DropdownMenuItem(
                    value: category,
                    child: Text(category.label(l10n)),
                  ),
              ],
              validator: (value) =>
                  value == null ? l10n.helpSupportCategoryRequired : null,
              onChanged: context.read<SendMessageCubit>().selectCategory,
            );
          },
        ),
      ],
    );
  }
}
