import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/features/event_details/ui/widgets/circle_icon_button.dart';
import 'package:evetick/features/event_details/ui/widgets/gallery_dots.dart';
import 'package:evetick/features/home/ui/widgets/event_cover_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Cover (swipe through the gallery) with back / favorite / share pinned
/// to the top corners.
class EventHeader extends StatefulWidget {
  const EventHeader({
    super.key,
    required this.images,
    required this.isFavorite,
    required this.onBack,
    required this.onFavorite,
    required this.onShare,
  });

  final List<String> images;
  final bool isFavorite;
  final VoidCallback onBack;
  final VoidCallback onFavorite;
  final VoidCallback onShare;

  @override
  State<EventHeader> createState() => _EventHeaderState();
}

class _EventHeaderState extends State<EventHeader> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final images = widget.images.isEmpty ? const [''] : widget.images;

    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          itemCount: images.length,
          onPageChanged: (i) => setState(() => _page = i),
          itemBuilder: (_, i) => EventCoverImage(url: images[i]),
        ),
        // keeps the buttons readable on bright covers
        IgnorePointer(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.center,
                colors: [
                  ColorsManager.black.withValues(alpha: 0.55),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                children: [
                  CircleIconButton(
                    icon: Icons.arrow_back_ios_new,
                    onTap: widget.onBack,
                  ),
                  const Spacer(),
                  CircleIconButton(
                    icon: widget.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: widget.isFavorite ? ColorsManager.favourite : null,
                    onTap: widget.onFavorite,
                  ),
                  SizedBox(width: 8.w),
                  CircleIconButton(
                    icon: Icons.share_outlined,
                    onTap: widget.onShare,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (images.length > 1)
          Positioned(
            bottom: 40.h,
            left: 0,
            right: 0,
            child: GalleryDots(count: images.length, current: _page),
          ),
      ],
    );
  }
}
