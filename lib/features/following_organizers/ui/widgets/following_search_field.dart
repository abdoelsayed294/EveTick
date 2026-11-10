import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/features/following_organizers/logic/following_organizers_cubit.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FollowingSearchField extends StatelessWidget {
  const FollowingSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return TextField(
      onChanged: context.read<FollowingOrganizersCubit>().search,
      style: TextStyle(color: colors.white, fontSize: 15.sp),
      cursorColor: ColorsManager.orange,
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)!.followingOrganizersSearch,
        hintStyle: TextStyle(color: colors.lightGray, fontSize: 15.sp),
        prefixIcon: Icon(Icons.search_rounded, color: colors.lightGray),
        filled: true,
        fillColor: colors.lightBlue,
        contentPadding: EdgeInsets.symmetric(vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
