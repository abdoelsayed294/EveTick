import 'package:evetick/core/routing/routes.dart';
import 'package:evetick/features/home/data/models/home_event_model.dart';
import 'package:evetick/features/home/logic/home_cubit.dart';
import 'package:evetick/features/home/logic/home_data.dart';
import 'package:evetick/features/home/ui/widgets/category_chips.dart';
import 'package:evetick/features/home/ui/widgets/home_empty_message.dart';
import 'package:evetick/features/home/ui/widgets/home_featured_section.dart';
import 'package:evetick/features/home/ui/widgets/home_header.dart';
import 'package:evetick/features/home/ui/widgets/home_popular_section.dart';
import 'package:evetick/features/home/ui/widgets/home_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key, required this.data});

  final HomeData data;

  Future<void> _openEvent(BuildContext context, HomeEvent event) async {
    final cubit = context.read<HomeCubit>();
    await Navigator.of(context)
        .pushNamed(Routes.eventDetailsScreen, arguments: event.id);
    cubit.load(silent: true);
  }

  Future<void> _openSearch(
    BuildContext context, {
    bool openFilters = false,
  }) async {
    final cubit = context.read<HomeCubit>();
    await Navigator.of(context)
        .pushNamed(Routes.searchScreen, arguments: openFilters);
    cubit.load(silent: true);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    final featured = data.featuredEvents;
    final popular = data.popularEvents;

    return RefreshIndicator(
      onRefresh: () => cubit.load(silent: true),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(height: 8.h),
                HomeHeader(
                  onNotificationsTap: () => Navigator.of(context)
                      .pushNamed(Routes.notificationsScreen),
                ),
                SizedBox(height: 24.h),
                HomeSearchField(
                  onSearchTap: () => _openSearch(context),
                  onFilterTap: () => _openSearch(context, openFilters: true),
                ),
                SizedBox(height: 24.h),
                CategoryChips(
                  categories: data.categories,
                  selected: data.selectedCategory,
                  onSelected: cubit.selectCategory,
                ),
                SizedBox(height: 24.h),
              ]),
            ),
          ),
          if (featured.isNotEmpty)
            HomeFeaturedSection(
              events: featured,
              badges: data.badges,
              onEventTap: (event) => _openEvent(context, event),
            ),
          if (popular.isNotEmpty)
            HomePopularSection(
              events: popular,
              favoriteIds: data.favoriteIds,
              onEventTap: (event) => _openEvent(context, event),
              onFavoriteTap: (event) => cubit.toggleFavorite(event.id),
            )
          else
            HomeEmptyMessage(hasEvents: data.events.isNotEmpty),
        ],
      ),
    );
  }
}
