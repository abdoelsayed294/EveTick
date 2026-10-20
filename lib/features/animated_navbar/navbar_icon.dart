import 'package:evetick/features/animated_navbar/navbar_icon_switcher.dart';
import 'package:evetick/features/animated_navbar/navbar_item.dart';
import 'package:flutter/material.dart';

class AnimatedNavbarIcon extends StatelessWidget {
  final AnimatedNavbarItem item;
  final bool selected;
  final Color activeColor;
  final Color inactiveColor;

  const AnimatedNavbarIcon({
    super.key,
    required this.item,
    required this.selected,
    required this.activeColor,
    required this.inactiveColor,
  });

  static const double _scaleBoost = 0.1;
  static const double _iconSize = 28;
  static const Duration _tweenDuration = Duration(milliseconds: 450);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(
          begin: selected ? 0 : 1,
          end: selected ? 1 : 0,
        ),
        duration: _tweenDuration,
        curve: Curves.easeOutBack,
        builder: (context, value, _) {
          return Transform.scale(
            scale: 1 + (_scaleBoost * value),
            child: IconTheme(
              data: IconThemeData(
                color: Color.lerp(inactiveColor, activeColor, value.clamp(0.0, 1.0)),
                size: _iconSize,
                shadows: [
                  Shadow(
                    color: activeColor.withValues(alpha: (0.6 * value).clamp(0.0, 1.0)),
                    blurRadius: (12 * value).clamp(0.0, 50.0),
                  ),
                ],
              ),
              child: NavbarIconSwitcher(item: item, selected: selected),
            ),
          );
        },
      ),
    );
  }
}
