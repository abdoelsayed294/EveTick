import 'package:evetick/features/animated_navbar/spotlight.dart';
import 'package:flutter/material.dart';

class NavbarSpotlightLayer extends StatelessWidget {
  const NavbarSpotlightLayer({
    super.key,
    required this.animation,
    required this.startX,
    required this.endX,
    required this.color,
  });

  final Animation<double> animation;
  final double startX;
  final double endX;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) {
        return Spotlight(
          progress: animation.value,
          startX: startX,
          endX: endX,
          color: color,
        );
      },
    );
  }
}
