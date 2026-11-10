import 'package:evetick/features/animated_navbar/navbar_icon.dart';
import 'package:evetick/features/animated_navbar/navbar_item.dart';
import 'package:flutter/material.dart';

class NavbarIconsRow extends StatelessWidget {
  const NavbarIconsRow({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    required this.activeColor,
    required this.inactiveColor,
  });

  final List<AnimatedNavbarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(items.length, (index) {
        return Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => onTap(index),
            child: AnimatedNavbarIcon(
              item: items[index],
              selected: currentIndex == index,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
            ),
          ),
        );
      }),
    );
  }
}
