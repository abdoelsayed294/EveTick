import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/colors.dart';

import 'package:evetick/features/event_booking/ui/widgets/select_chair_widgets/legend_item.dart';
import 'package:flutter/material.dart';

class SeatLegend extends StatelessWidget {
  const SeatLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        LegendItem(color: ColorsManager.chairColor, label: 'Available'),
        horizontalSpace(56),
        LegendItem(color: ColorsManager.lightBlue, label: 'Reserved'),
        horizontalSpace(56),
        LegendItem(color: ColorsManager.orange, label: 'Selected'),
      ],
    );
  }
}
