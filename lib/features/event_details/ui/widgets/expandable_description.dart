import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Description cut to [maxLines] with a "Read More" / "Show Less" toggle
/// (the toggle only shows when the text is actually longer).
class ExpandableDescription extends StatefulWidget {
  const ExpandableDescription({
    super.key,
    required this.text,
    this.maxLines = 4,
  });

  final String text;
  final int maxLines;

  @override
  State<ExpandableDescription> createState() => _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<ExpandableDescription> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: 16.sp,
      height: 1.5,
      color: context.colors.lightGray,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final painter = TextPainter(
          text: TextSpan(text: widget.text, style: style),
          maxLines: widget.maxLines,
          textDirection: Directionality.of(context),
        )..layout(maxWidth: constraints.maxWidth);
        final overflows = painter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.text,
              style: style,
              maxLines: _expanded ? null : widget.maxLines,
              overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
            if (overflows)
              GestureDetector(
                onTap: () => setState(() => _expanded = !_expanded),
                child: Padding(
                  padding: EdgeInsets.only(top: 4.h),
                  child: Text(
                    _expanded ? 'Show Less' : 'Read More',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: ColorsManager.orange,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
