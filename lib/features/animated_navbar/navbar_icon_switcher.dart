import 'package:evetick/features/animated_navbar/navbar_item.dart';
import 'package:flutter/material.dart';

class NavbarIconSwitcher extends StatelessWidget {
  const NavbarIconSwitcher({
    super.key,
    required this.item,
    required this.selected,
  });

  final AnimatedNavbarItem item;
  final bool selected;

  static const Duration _switchDuration = Duration(milliseconds: 250);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: _switchDuration,
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) {
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
              key: const ValueKey('active'),
              child: item.activeIcon ?? item.icon,
            )
          : KeyedSubtree(
              key: const ValueKey('inactive'),
              child: item.icon,
            ),
    );
  }
}
