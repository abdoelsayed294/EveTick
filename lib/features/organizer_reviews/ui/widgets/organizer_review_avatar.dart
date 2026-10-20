import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrganizerReviewAvatar extends StatelessWidget {
  const OrganizerReviewAvatar({super.key, this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      color: context.colors.thirdBlue,
      alignment: Alignment.center,
      child: Icon(Icons.person, color: context.colors.lightGray, size: 26.sp),
    );

    return ClipOval(
      child: SizedBox(
        width: 48.w,
        height: 48.w,
        child: url == null
            ? placeholder
            : Image.network(
                url!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => placeholder,
              ),
      ),
    );
  }
}
