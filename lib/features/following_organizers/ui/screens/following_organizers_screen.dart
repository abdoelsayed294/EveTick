import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/features/following_organizers/ui/widgets/following_app_bar.dart';
import 'package:evetick/features/following_organizers/ui/widgets/following_organizers_bloc_builder.dart';
import 'package:evetick/features/following_organizers/ui/widgets/following_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FollowingOrganizersScreen extends StatelessWidget {
  const FollowingOrganizersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              verticalSpace(16),
              const FollowingAppBar(),
              verticalSpace(16),
              const FollowingSearchField(),
              verticalSpace(16),
              const Expanded(child: FollowingOrganizersBlocBuilder()),
            ],
          ),
        ),
      ),
    );
  }
}
