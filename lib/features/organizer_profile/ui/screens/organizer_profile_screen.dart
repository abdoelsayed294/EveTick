import 'package:evetick/core/helpers/count_formatter.dart';
import 'package:evetick/core/routing/routes.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/widgets/app_empty_view.dart';
import 'package:evetick/core/widgets/app_error_view.dart';
import 'package:evetick/features/following_organizers/ui/widgets/follow_button.dart';
import 'package:evetick/features/home/data/models/home_event_model.dart';
import 'package:evetick/features/home/ui/widgets/event_cover_image.dart';
import 'package:evetick/features/organizer_profile/data/models/organizer_profile_model.dart';
import 'package:evetick/features/organizer_profile/logic/organizer_profile_cubit.dart';
import 'package:evetick/features/organizer_profile/logic/organizer_profile_state.dart';
import 'package:evetick/features/organizer_profile/ui/widgets/organizer_event_card.dart';
import 'package:evetick/features/organizer_profile/ui/widgets/organizer_stat_card.dart';
import 'package:evetick/features/organizer_profile/ui/widgets/organizer_tab_switch.dart';
import 'package:evetick/features/organizer_reviews/ui/widgets/organizer_reviews_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Public page of an organizer. Receives the organizer's uid from the router.
class OrganizerProfileScreen extends StatelessWidget {
  const OrganizerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<OrganizerProfileCubit, OrganizerProfileState>(
        builder: (context, state) {
          switch (state.status) {
            case OrganizerProfileStatus.loading:
              return Stack(
                children: [
                  const Center(child: CircularProgressIndicator()),
                  const _BackButton(),
                ],
              );
            case OrganizerProfileStatus.error:
              return Stack(
                children: [
                  AppErrorView(message: state.errorMessage),
                  const _BackButton(),
                ],
              );
            case OrganizerProfileStatus.success:
              return Stack(
                children: [
                  _Content(state: state, profile: state.profile!),
                  const _BackButton(),
                ],
              );
          }
        },
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.state, required this.profile});

  final OrganizerProfileState state;
  final OrganizerProfile profile;

  void _openEvent(BuildContext context, HomeEvent event) {
    Navigator.of(context)
        .pushNamed(Routes.eventDetailsScreen, arguments: event.id);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cubit = context.read<OrganizerProfileCubit>();
    final bio = profile.bio;
    const avatarSize = 96.0;

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner + avatar overlapping its bottom edge + follow button.
          SizedBox(
            height: 200.h + (avatarSize.w / 2),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  height: 200.h,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      EventCoverImage(url: profile.bannerUrl ?? ''),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              colors.darkBlue.withValues(alpha: 0.9),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 16.w,
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: colors.darkBlue,
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: SizedBox(
                        width: avatarSize.w,
                        height: avatarSize.w,
                        child: EventCoverImage(url: profile.avatarUrl ?? ''),
                      ),
                    ),
                  ),
                ),
                if (state.canFollow)
                  Positioned(
                    right: 16.w,
                    bottom: 4.h,
                    child: FollowButton(
                      isFollowing: state.isFollowing,
                      onPressed: cubit.toggleFollow,
                      width: 140.w,
                      height: 48.h,
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        profile.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w700,
                          color: colors.white,
                        ),
                      ),
                    ),
                    if (profile.isVerified) ...[
                      SizedBox(width: 8.w),
                      Icon(Icons.verified_outlined,
                          size: 22.sp, color: ColorsManager.orange),
                    ],
                  ],
                ),
                if (bio != null) ...[
                  SizedBox(height: 12.h),
                  Text(
                    bio,
                    style: TextStyle(
                      fontSize: 15.sp,
                      height: 1.5,
                      color: colors.lightGray,
                    ),
                  ),
                ],
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Expanded(
                      child: OrganizerStatCard(
                        value: '${profile.eventsHosted}',
                        label: 'Events Hosted',
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: OrganizerStatCard(
                        value: formatCount(profile.followers),
                        label: 'Followers',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                OrganizerTabSwitch(
                  selected: state.tab,
                  onSelected: cubit.selectTab,
                ),
                SizedBox(height: 20.h),
                _TabContent(
                  tab: state.tab,
                  profile: profile,
                  onOpenEvent: (event) => _openEvent(context, event),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabContent extends StatelessWidget {
  const _TabContent({
    required this.tab,
    required this.profile,
    required this.onOpenEvent,
  });

  final OrganizerProfileTab tab;
  final OrganizerProfile profile;
  final ValueChanged<HomeEvent> onOpenEvent;

  @override
  Widget build(BuildContext context) {
    switch (tab) {
      case OrganizerProfileTab.upcoming:
        return _eventsList(profile.upcomingEvents, 'No upcoming events');
      case OrganizerProfileTab.past:
        return _eventsList(profile.pastEvents, 'No past events');
      case OrganizerProfileTab.reviews:
        return OrganizerReviewsTab(organizerId: profile.id);
    }
  }

  Widget _eventsList(List<HomeEvent> events, String emptyMessage) {
    if (events.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: 40.h),
        child: AppEmptyView(message: emptyMessage),
      );
    }
    return Column(
      children: [
        for (final event in events) ...[
          OrganizerEventCard(event: event, onTap: () => onOpenEvent(event)),
          SizedBox(height: 16.h),
        ],
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: GestureDetector(
          onTap: () => Navigator.of(context).maybePop(),
          child: Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.35),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back_ios_new_rounded,
                size: 18.sp, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
