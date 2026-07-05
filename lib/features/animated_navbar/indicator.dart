import 'dart:ui';

import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  final double progress;

  final double startX;

  final double endX;

  final Color color;

  const Indicator({
    super.key,
    required this.progress,
    required this.startX,
    required this.endX,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final x = lerpDouble(
      startX,
      endX,
      progress,
    )!;

    return Positioned(
      left: x - 18,
      top: 8,
      child: Container(
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
}