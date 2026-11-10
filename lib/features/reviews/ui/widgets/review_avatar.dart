import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:evetick/core/theming/extensions/build_context_extension.dart';

class ReviewAvatar extends StatelessWidget {
  const ReviewAvatar({super.key, this.url});

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
