import 'package:evetick/features/animated_navbar/indicator.dart';
import 'package:evetick/features/animated_navbar/navbar_icon.dart';
import 'package:evetick/features/animated_navbar/navbar_item.dart';
import 'package:evetick/features/animated_navbar/spotlight.dart';
import 'package:flutter/material.dart';



class AnimatedSpotlightNavbar extends StatefulWidget {
  const AnimatedSpotlightNavbar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.height = 80,
    this.backgroundColor = const Color(0xff173A5E),
    this.activeColor = Colors.orange,
    this.inactiveColor = Colors.white,
    this.borderRadius = 24,
    this.animationDuration = const Duration(milliseconds: 500),
  });

  final List<AnimatedNavbarItem> items;

  final int currentIndex;

  final ValueChanged<int> onTap;

  final double height;

  final double borderRadius;

  final Color backgroundColor;

  final Color activeColor;

  final Color inactiveColor;

  final Duration animationDuration;

  @override
  State<AnimatedSpotlightNavbar> createState() =>
      _AnimatedSpotlightNavbarState();
}

class _AnimatedSpotlightNavbarState
    extends State<AnimatedSpotlightNavbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _animation;

  double _start = 0;

  double _end = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _start = _calculateCenter(widget.currentIndex);
      _end = _start;
      setState(() {});
    });
  }

  @override
  void didUpdateWidget(covariant AnimatedSpotlightNavbar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.currentIndex != widget.currentIndex) {
      _start = _end;
      _end = _calculateCenter(widget.currentIndex);

      _controller
        ..reset()
        ..forward();
    }
  }

  double _calculateCenter(int index) {
    final width = MediaQuery.of(context).size.width;

    final itemWidth = width / widget.items.length;

    return itemWidth * index + itemWidth / 2;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(
          widget.borderRadius,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          widget.borderRadius,
        ),
        child: Stack(
          children: [

            /// Spotlight
            AnimatedBuilder(
              animation: _animation,
              builder: (_, __) {
                return Spotlight(
                  progress: _animation.value,
                  startX: _start,
                  endX: _end,
                  color: widget.activeColor,
                );
              },
            ),

            /// Indicator
            AnimatedBuilder(
              animation: _animation,
              builder: (_, __) {
                return Indicator(
                  progress: _animation.value,
                  startX: _start,
                  endX: _end,
                  color: widget.activeColor,
                );
              },
            ),

            /// Icons
            Row(
              children: List.generate(
                widget.items.length,
                (index) {
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => widget.onTap(index),
                      child: AnimatedNavbarIcon(
                        item: widget.items[index],
                        selected:
                            widget.currentIndex == index,
                        activeColor: widget.activeColor,
                        inactiveColor:
                            widget.inactiveColor,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}