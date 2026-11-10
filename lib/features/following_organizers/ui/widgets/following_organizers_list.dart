import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/routing/routes.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/core/widgets/app_empty_view.dart';
import 'package:evetick/features/following_organizers/data/models/followed_organizer_model.dart';
import 'package:evetick/features/following_organizers/logic/following_organizers_cubit.dart';
import 'package:evetick/features/following_organizers/ui/widgets/organizer_tile.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FollowingOrganizersList extends StatelessWidget {
  const FollowingOrganizersList({super.key, required this.organizers});

  final List<FollowedOrganizer> organizers;

  Future<void> _openOrganizer(BuildContext context, String organizerId) async {
    final cubit = context.read<FollowingOrganizersCubit>();
    await Navigator.of(context)
        .pushNamed(Routes.organizerProfileScreen, arguments: organizerId);
    cubit.load(silent: true);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FollowingOrganizersCubit>();
    final l10n = AppLocalizations.of(context)!;

    return RefreshIndicator(
      onRefresh: () => cubit.load(silent: true),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: 24.h),
        children: [
          Text(
            l10n.followingOrganizersCount('${cubit.totalCount}'),
            style: TextStyles.font16WhiteBold(context),
          ),
          verticalSpace(8),
          if (organizers.isEmpty) ...[
            SizedBox(height: 120.h),
            AppEmptyView(
              message: cubit.totalCount == 0
                  ? l10n.followingOrganizersEmpty
                  : l10n.followingOrganizersNoResults,
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
