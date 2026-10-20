import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TicketDivider extends StatelessWidget {
  const TicketDivider({super.key, required this.notchColor});

  final Color notchColor;

  @override
  Widget build(BuildContext context) {
    final double notch = 24.w;

    Widget circle() => Container(
          width: notch,
          height: notch,
          decoration: BoxDecoration(color: notchColor, shape: BoxShape.circle),
        );

    return SizedBox(
      height: notch,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final dashes = (constraints.maxWidth / 10).floor();
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    dashes,
                    (_) => Container(
                      width: 5,
                      height: 1.5,
                      color: Colors.grey.shade400,
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(left: -notch / 2, child: circle()),
          Positioned(right: -notch / 2, child: circle()),
        ],
      ),
    );
  }
}
