import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/features/organizer_profile/logic/organizer_profile_tab.dart';
import 'package:evetick/features/organizer_profile/ui/widgets/organizer_tab_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          OrganizerTabItem(
            label: 'Upcoming',
            isSelected: selected == OrganizerProfileTab.upcoming,
            onTap: () => onSelected(OrganizerProfileTab.upcoming),
          ),
          OrganizerTabItem(
            label: 'Past Events',
            isSelected: selected == OrganizerProfileTab.past,
            onTap: () => onSelected(OrganizerProfileTab.past),
          ),
          OrganizerTabItem(
            label: 'Reviews',
            isSelected: selected == OrganizerProfileTab.reviews,
            onTap: () => onSelected(OrganizerProfileTab.reviews),
          ),
        ],
      ),
    );
  }
}
