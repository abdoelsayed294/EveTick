import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/routing/routes.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/core/widgets/app_empty_view.dart';
import 'package:evetick/core/widgets/app_error_view.dart';
import 'package:evetick/features/favorites/logic/favorites_cubit.dart';
import 'package:evetick/features/favorites/logic/favorites_state.dart';
import 'package:evetick/features/favorites/ui/widgets/favorite_event_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  Future<void> _openEvent(BuildContext context, String eventId) async {
    final cubit = context.read<FavoritesCubit>();
    await Navigator.of(context)
        .pushNamed(Routes.eventDetailsScreen, arguments: eventId);
    // The heart may have been changed on the details screen.
    cubit.load(silent: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              verticalSpace(30),
              Text('Favorites', style: TextStyles.font18WhiteBold(context)),
              verticalSpace(16),
              Expanded(
                child: BlocBuilder<FavoritesCubit, FavoritesState>(
                  builder: (context, state) => _buildBody(context, state),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, FavoritesState state) {
    final cubit = context.read<FavoritesCubit>();

    switch (state.status) {
      case FavoritesStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case FavoritesStatus.error:
        return AppErrorView(message: state.errorMessage, onRetry: cubit.load);
      case FavoritesStatus.success:
        return RefreshIndicator(
          onRefresh: () => cubit.load(silent: true),
          child: state.events.isEmpty
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: 200.h),
                    const AppEmptyView(message: 'No favorites yet'),
                  ],
                )
              : ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  // Room for the floating navbar.
                  padding: EdgeInsets.only(bottom: 120.h),
                  itemCount: state.events.length,
                  separatorBuilder: (_, __) => SizedBox(height: 16.h),
                  itemBuilder: (context, index) {
                    final event = state.events[index];
                    return FavoriteEventCard(
                      event: event,
                      onTap: () => _openEvent(context, event.id),
                      onRemove: () => cubit.removeFavorite(event.id),
                    );
                  },
                ),
        );
    }
  }
}
