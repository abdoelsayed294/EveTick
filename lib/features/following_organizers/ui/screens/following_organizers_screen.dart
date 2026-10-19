import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/routing/routes.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/core/widgets/app_empty_view.dart';
import 'package:evetick/core/widgets/app_error_view.dart';
import 'package:evetick/features/following_organizers/logic/following_organizers_cubit.dart';
import 'package:evetick/features/following_organizers/logic/following_organizers_state.dart';
import 'package:evetick/features/following_organizers/ui/widgets/organizer_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// My profile -> Following Organizers.
class FollowingOrganizersScreen extends StatelessWidget {
  const FollowingOrganizersScreen({super.key});

  Future<void> _openOrganizer(BuildContext context, String organizerId) async {
    final cubit = context.read<FollowingOrganizersCubit>();
    await Navigator.of(context)
        .pushNamed(Routes.organizerProfileScreen, arguments: organizerId);
    // The user may have (un)followed on the organizer page.
    cubit.load(silent: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              verticalSpace(16),
              _AppBar(),
              verticalSpace(16),
              const _SearchField(),
              verticalSpace(16),
              Expanded(
                child: BlocBuilder<FollowingOrganizersCubit, FollowingOrganizersState>(
                  builder: (context, state) => _buildBody(context, state),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, FollowingOrganizersState state) {
    final cubit = context.read<FollowingOrganizersCubit>();

    switch (state.status) {
      case FollowingOrganizersStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case FollowingOrganizersStatus.error:
        return AppErrorView(message: state.errorMessage, onRetry: cubit.load);
      case FollowingOrganizersStatus.success:
        final organizers = state.visible;
        return RefreshIndicator(
          onRefresh: () => cubit.load(silent: true),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(bottom: 24.h),
            children: [
              Text(
                'Organizers (${state.organizers.length})',
                style: TextStyles.font16WhiteBold(context),
              ),
              verticalSpace(8),
              if (organizers.isEmpty) ...[
                SizedBox(height: 120.h),
                AppEmptyView(
                  message: state.organizers.isEmpty
                      ? 'You are not following any organizer yet'
                      : 'No organizers found',
                ),
              ] else
                for (final organizer in organizers)
                  OrganizerTile(
                    organizer: organizer,
                    onTap: () => _openOrganizer(context, organizer.id),
                    onToggleFollow: () => cubit.toggleFollow(organizer.id),
                  ),
            ],
          ),
        );
    }
  }
}

class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.of(context).maybePop(),
              child: Icon(Icons.arrow_back_ios_new_rounded,
                  size: 20.sp, color: context.colors.white),
            ),
          ),
          Text('Following Organizers', style: TextStyles.font18WhiteBold(context)),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return TextField(
      onChanged: context.read<FollowingOrganizersCubit>().search,
      style: TextStyle(color: colors.white, fontSize: 15.sp),
      cursorColor: ColorsManager.orange,
      decoration: InputDecoration(
        hintText: 'Search organizers',
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
