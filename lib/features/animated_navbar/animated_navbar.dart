import 'package:evetick/core/theming/app_colors.dart';
import 'package:evetick/core/theming/colors.dart';

import 'package:evetick/features/animated_navbar/navbar_icons_row.dart';
import 'package:evetick/features/animated_navbar/navbar_indicator_layer.dart';
import 'package:evetick/features/animated_navbar/navbar_item.dart';
import 'package:evetick/features/animated_navbar/navbar_spotlight_layer.dart';
import 'package:flutter/material.dart';

class AnimatedSpotlightNavbar extends StatefulWidget {
  final List<AnimatedNavbarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final double height;
  final double borderRadius;
  final Color? backgroundColor;
  final Color activeColor;
  final Color? inactiveColor;
  final Duration animationDuration;

  const AnimatedSpotlightNavbar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.height = 72,
    this.backgroundColor,
    this.activeColor = ColorsManager.orange,
    this.inactiveColor,
    this.borderRadius = 24,
    this.animationDuration = const Duration(milliseconds: 500),
  });

  @override
  State<AnimatedSpotlightNavbar> createState() =>
      _AnimatedSpotlightNavbarState();
}

class _AnimatedSpotlightNavbarState extends State<AnimatedSpotlightNavbar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  double _startX = 0;
  double _endX = 0;

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
      final center = _calculateCenterX(widget.currentIndex);
      setState(() {
        _startX = center;
        _endX = center;
      });
    });
  }

  @override
  void didUpdateWidget(covariant AnimatedSpotlightNavbar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.currentIndex != widget.currentIndex) {
      _startX = _endX;
      _endX = _calculateCenterX(widget.currentIndex);
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _calculateCenterX(int index) {
    final totalWidth = MediaQuery.of(context).size.width;
    final itemWidth = totalWidth / widget.items.length;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final visualIndex = isRtl ? widget.items.length - 1 - index : index;
    return itemWidth * visualIndex + itemWidth / 2;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final center = _calculateCenterX(widget.currentIndex);
    _startX = center;
    _endX = center;
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final colors = Theme.of(context).extension<AppColors>()!;

    return Container(
      height: widget.height + bottomPadding,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? colors.lightBlue,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(widget.borderRadius),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(widget.borderRadius),
        ),
        child: Stack(
          children: [
            NavbarSpotlightLayer(
              animation: _animation,
              startX: _startX,
              endX: _endX,
              color: widget.activeColor,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: bottomPadding),
              child: Stack(
                children: [
                  NavbarIndicatorLayer(
                    animation: _animation,
                    startX: _startX,
                    endX: _endX,
                    color: widget.activeColor,
                  ),
                  NavbarIconsRow(
                    items: widget.items,
                    currentIndex: widget.currentIndex,
                    onTap: widget.onTap,
                    activeColor: widget.activeColor,
                    inactiveColor: widget.inactiveColor ?? colors.lightGray,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
