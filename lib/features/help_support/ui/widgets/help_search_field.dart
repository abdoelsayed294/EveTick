import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/features/help_support/logic/help_cubit.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HelpSearchField extends StatelessWidget {
  const HelpSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: context.read<HelpCubit>().search,
      style: TextStyles.font16WhiteRegular(context),
      decoration: InputDecoration(
        filled: true,
        fillColor: context.colors.lightBlue,
        hintText: AppLocalizations.of(context)!.helpSupportHowCanWeHelp,
        hintStyle: TextStyles.font16LightGrayRegular(context),
        prefixIcon: Icon(Icons.search, color: context.colors.lightGray),
        contentPadding: EdgeInsets.symmetric(vertical: 14.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: ColorsManager.orange, width: 1.3),
        ),
      ),
    );
  }
}
