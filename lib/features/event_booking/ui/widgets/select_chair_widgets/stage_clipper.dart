import 'package:flutter/material.dart';

class StageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final double inset = size.width * 0.08;

    return Path()
      ..moveTo(inset, 0)
      ..lineTo(size.width - inset, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
