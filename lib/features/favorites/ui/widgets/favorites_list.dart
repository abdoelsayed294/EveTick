import 'package:evetick/core/routing/routes.dart';
import 'package:evetick/core/widgets/app_empty_view.dart';
import 'package:evetick/features/favorites/logic/favorites_cubit.dart';
import 'package:evetick/features/favorites/ui/widgets/favorite_event_card.dart';
import 'package:evetick/features/home/data/models/home_event_model.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavoritesList extends StatelessWidget {
  const FavoritesList({super.key, required this.events});

  final List<HomeEvent> events;

  Future<void> _openEvent(BuildContext context, String eventId) async {
    final cubit = context.read<FavoritesCubit>();
    await Navigator.of(context)
        .pushNamed(Routes.eventDetailsScreen, arguments: eventId);
    cubit.load(silent: true);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FavoritesCubit>();

    return RefreshIndicator(
      onRefresh: () => cubit.load(silent: true),
      child: events.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: 200.h),
                AppEmptyView(
                  message: AppLocalizations.of(context)!.favoritesEmpty,
                ),
              ],
            )
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(bottom: 120.h),
              itemCount: events.length,
              separatorBuilder: (_, __) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                final event = events[index];
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
