import 'package:evetick/core/routing/routes.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/features/home/data/models/home_event_model.dart';
import 'package:evetick/features/home/logic/home_cubit.dart';
import 'package:evetick/features/home/logic/home_state.dart';
import 'package:evetick/features/home/ui/widgets/category_chips.dart';
import 'package:evetick/features/home/ui/widgets/featured_events_carousel.dart';
import 'package:evetick/features/home/ui/widgets/home_header.dart';
import 'package:evetick/features/home/ui/widgets/home_search_field.dart';
import 'package:evetick/features/home/ui/widgets/popular_event_tile.dart';
import 'package:evetick/features/home/ui/widgets/section_header.dart';
import 'package:evetick/core/widgets/app_error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _openEvent(BuildContext context, HomeEvent event) async {
    final cubit = context.read<HomeCubit>();
    await Navigator.of(context)
        .pushNamed(Routes.eventDetailsScreen, arguments: event.id);
    // The heart / tickets may have changed on the details screen.
    cubit.load(silent: true);
  }

  Future<void> _openSearch(
    BuildContext context, {
    bool openFilters = false,
  }) async {
    final cubit = context.read<HomeCubit>();
    await Navigator.of(context)
        .pushNamed(Routes.searchScreen, arguments: openFilters);
    // Hearts may have changed in the search results.
    cubit.load(silent: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            switch (state.status) {
              case HomeStatus.loading:
                return const Center(child: CircularProgressIndicator());
              case HomeStatus.error:
                return AppErrorView(
                  message: state.errorMessage,
                  onRetry: () => context.read<HomeCubit>().load(),
                );
              case HomeStatus.success:
                return _buildContent(context, state);
            }
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, HomeState state) {
    final cubit = context.read<HomeCubit>();
    final featured = state.featuredEvents;
    final popular = state.popularEvents;

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
                const HomeHeader(),
                SizedBox(height: 24.h),
                HomeSearchField(
                  onSearchTap: () => _openSearch(context),
                  onFilterTap: () => _openSearch(context, openFilters: true),
                ),
                SizedBox(height: 24.h),
                CategoryChips(
                  categories: state.categories,
                  selected: state.selectedCategory,
                  onSelected: cubit.selectCategory,
                ),
                SizedBox(height: 24.h),
              ]),
            ),
          ),
          if (featured.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                // TODO: wire "See All" once the events list screen exists
                child: const SectionHeader(title: 'Featured Events'),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 16.h)),
            SliverToBoxAdapter(
              child: FeaturedEventsCarousel(
                events: featured,
                badges: state.badges,
                onBook: (event) => _openEvent(context, event),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 24.h)),
          ],
          if (popular.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: const SectionHeader(title: 'Popular Events'),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 16.h)),
            SliverPadding(
              // Room for the floating navbar.
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 120.h),
              sliver: SliverList.separated(
                itemCount: popular.length,
                separatorBuilder: (_, __) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  final event = popular[index];
                  return PopularEventTile(
                    event: event,
                    isFavorite: state.favoriteIds.contains(event.id),
                    onTap: () => _openEvent(context, event),
                    onFavoriteTap: () => cubit.toggleFavorite(event.id),
                  );
                },
              ),
            ),
          ] else
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 120.h),
                  child: Text(
                    state.events.isEmpty
                        ? 'No events yet'
                        : 'No events match your search',
                    style: TextStyles.font16LightGrayRegular(context),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
