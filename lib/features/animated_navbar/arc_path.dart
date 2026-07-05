import 'dart:ui';

import 'package:flutter/material.dart';

class ArcPath {
  static Offset calculate({
    required double progress,
    required double startX,
    required double endX,
    double top = -35,
  }) {
    final path = Path();

    path.moveTo(startX, 0);

    path.quadraticBezierTo(
      (startX + endX) / 2,
      top,
      endX,
      0,
    );

    final metric = path.computeMetrics().first;

    final tangent = metric.getTangentForOffset(
      metric.length * progress,
    );

    return tangent!.position;
  }
}