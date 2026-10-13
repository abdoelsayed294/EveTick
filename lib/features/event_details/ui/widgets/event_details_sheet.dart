import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Rounded panel that overlaps the bottom of the cover.
class EventDetailsSheet extends StatelessWidget {
  const EventDetailsSheet({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: child,
    );
  }
}
