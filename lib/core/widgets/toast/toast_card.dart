import 'dart:async';

import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/widgets/toast/toast_type.dart';
import 'package:evetick/core/widgets/toast/toast_type_style.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ToastCard extends StatefulWidget {
  const ToastCard({
    super.key,
    required this.type,
    required this.message,
    required this.duration,
    required this.onClosed,
  });

  final ToastType type;
  final String message;
  final Duration duration;
  final VoidCallback onClosed;

  @override
  State<ToastCard> createState() => _ToastCardState();
}

class _ToastCardState extends State<ToastCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 280),
    reverseDuration: const Duration(milliseconds: 220),
  );
  late final Animation<Offset> _slide = Tween<Offset>(
    begin: const Offset(0, -1.4),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

  Timer? _timer;
  bool _closing = false;

  @override
  void initState() {
    super.initState();
    _controller.forward();
    _timer = Timer(widget.duration, _close);
  }

  Future<void> _close() async {
    if (_closing) return;
    _closing = true;
    _timer?.cancel();
    await _controller.reverse();
    if (mounted) widget.onClosed();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final accent = widget.type.color;
    final title = widget.type.title(AppLocalizations.of(context)!);

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
          child: SlideTransition(
            position: _slide,
            child: FadeTransition(
              opacity: _controller,
              child: GestureDetector(
                onTap: _close,
                onVerticalDragEnd: (details) {
                  if ((details.primaryVelocity ?? 0) < 0) _close();
                },
                child: Semantics(
                  liveRegion: true,
                  label: '$title. ${widget.message}',
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: colors.lightBlue,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: accent.withOpacity(0.7),
                          width: 1.2,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x40000000),
                            blurRadius: 16,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(
                              color: accent.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              widget.type.icon,
                              color: accent,
                              size: 22.sp,
                            ),
                          ),
                          horizontalSpace(12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w700,
                                    color: colors.white,
                                  ),
                                ),
                                if (widget.message.isNotEmpty) ...[
                                  verticalSpace(2),
                                  Text(
                                    widget.message,
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      height: 1.4,
                                      color: colors.lightGray,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
