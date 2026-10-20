import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/features/my_tickets/logic/my_tickets_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evetick/l10n/app_localizations.dart';

/// Upcoming / Past switch.
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
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: context.colors.lightBlue,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          _item(context, AppLocalizations.of(context)!.myTicketsTabsUpcoming, MyTicketsTab.upcoming),
          _item(context, AppLocalizations.of(context)!.myTicketsTabsPast, MyTicketsTab.past),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, String label, MyTicketsTab tab) {
    final isSelected = tab == selected;

    return Expanded(
      child: GestureDetector(
        onTap: () => onSelected(tab),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 44.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? ColorsManager.orange : Colors.transparent,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: context.colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
