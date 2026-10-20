import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/features/my_tickets/logic/my_tickets_tab.dart';
import 'package:evetick/features/my_tickets/ui/widgets/my_tickets_tab_item.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evetick/l10n/app_localizations.dart';

class MyTicketsTabSwitch extends StatelessWidget {
  const MyTicketsTabSwitch({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final MyTicketsTab selected;
  final ValueChanged<MyTicketsTab> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: context.colors.lightBlue,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          MyTicketsTabItem(
            label: l10n.myTicketsTabsUpcoming,
            isSelected: selected == MyTicketsTab.upcoming,
            onTap: () => onSelected(MyTicketsTab.upcoming),
          ),
          MyTicketsTabItem(
            label: l10n.myTicketsTabsPast,
            isSelected: selected == MyTicketsTab.past,
            onTap: () => onSelected(MyTicketsTab.past),
          ),
        ],
      ),
    );
  }
}
