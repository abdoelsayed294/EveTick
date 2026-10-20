import 'package:flutter/material.dart';

class DashedLine extends StatelessWidget {
  const DashedLine({
    super.key,
    required this.color,
    this.dashWidth = 5,
    this.gap = 4,
    this.thickness = 1,
  });

  final Color color;
  final double dashWidth;
  final double gap;
  final double thickness;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = (constraints.maxWidth / (dashWidth + gap)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            count,
            (_) => Container(width: dashWidth, height: thickness, color: color),
          ),
        );
      },
    );
  }
}
