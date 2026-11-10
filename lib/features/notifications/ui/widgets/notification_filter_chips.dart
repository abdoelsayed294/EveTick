import 'package:evetick/features/notifications/data/models/notification_filter.dart';
import 'package:evetick/features/notifications/logic/notifications_cubit/notifications_cubit.dart';
import 'package:evetick/features/notifications/ui/widgets/notification_filter_chip.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationFilterChips extends StatelessWidget {
  const NotificationFilterChips({super.key});

  String _label(AppLocalizations l10n, NotificationFilter filter) {
    switch (filter) {
      case NotificationFilter.all:
        return l10n.homeFiltersAll;
      case NotificationFilter.events:
        return l10n.homeFiltersEvents;
      case NotificationFilter.tickets:
        return l10n.homeFiltersTickets;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NotificationsCubit>();
    final l10n = AppLocalizations.of(context)!;

    return ValueListenableBuilder<NotificationFilter>(
      valueListenable: cubit.filter,
      builder: (context, selected, _) {
        return SizedBox(
          height: 40.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: NotificationFilter.values.length,
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              final filter = NotificationFilter.values[index];
              return NotificationFilterChip(
                label: _label(l10n, filter),
                isSelected: filter == selected,
                onTap: () => cubit.setFilter(filter),
              );
            },
          ),
        );
      },
    );
  }
}
