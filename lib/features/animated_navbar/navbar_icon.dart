import 'package:evetick/features/animated_navbar/navbar_item.dart';
import 'package:flutter/material.dart';



class AnimatedNavbarIcon extends StatelessWidget {
  const AnimatedNavbarIcon({
    super.key,
    required this.item,
    required this.selected,
    required this.activeColor,
    required this.inactiveColor,
  });

  final AnimatedNavbarItem item;
  final bool selected;

  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(
          begin: selected ? 0 : 1,
          end: selected ? 1 : 0,
        ),
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          return Transform.translate(
            offset: Offset(
              0,
              -10 * value,
            ),
            child: Transform.scale(
              scale: 1 + (.15 * value),
              child: IconTheme(
                data: IconThemeData(
                  color: Color.lerp(
                    inactiveColor,
                    activeColor,
                    value,
                  ),
                  size: 28,
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(
                    milliseconds: 250,
                  ),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder:
                      (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    );
                  },
                  child: selected
                      ? KeyedSubtree(
                          key: const ValueKey("active"),
                          child: item.activeIcon ??
                              item.icon,
                        )
                      : KeyedSubtree(
                          key: const ValueKey("inactive"),
                          child: item.icon,
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}