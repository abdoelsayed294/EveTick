import 'dart:ui';

import 'package:flutter/material.dart';

class SpotlightPainter extends CustomPainter {
  final double centerX;

  final Color color;

  const SpotlightPainter({required this.centerX, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();

    path.moveTo(centerX, 0);

    path.quadraticBezierTo(centerX - 18, 22, centerX - 65, size.height);

    path.lineTo(centerX + 65, size.height);

    path.quadraticBezierTo(centerX + 18, 22, centerX, 0);

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withOpacity(.55),
          color.withOpacity(.18),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(centerX - 60, 0, 120, size.height));

    canvas.drawShadow(path, color.withOpacity(.45), 18, false);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant SpotlightPainter oldDelegate) {
    return oldDelegate.centerX != centerX;
  }
}
