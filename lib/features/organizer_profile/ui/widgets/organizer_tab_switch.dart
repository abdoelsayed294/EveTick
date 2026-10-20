import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/features/organizer_profile/logic/organizer_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Upcoming / Past Events / Reviews.
class OrganizerTabSwitch extends StatelessWidget {
  const OrganizerTabSwitch({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final OrganizerProfileTab selected;
  final ValueChanged<OrganizerProfileTab> onSelected;

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
          _item(context, 'Upcoming', OrganizerProfileTab.upcoming),
          _item(context, 'Past Events', OrganizerProfileTab.past),
          _item(context, 'Reviews', OrganizerProfileTab.reviews),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, String label, OrganizerProfileTab tab) {
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
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: context.colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
