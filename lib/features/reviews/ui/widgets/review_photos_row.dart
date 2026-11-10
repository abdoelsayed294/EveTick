import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewPhotosRow extends StatelessWidget {
  const ReviewPhotosRow({super.key, required this.urls});

  final List<String> urls;

  void _open(BuildContext context, String url) {
    showDialog<void>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(16.w),
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: InteractiveViewer(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.network(url, fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80.w,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: urls.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => _open(context, urls[index]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: SizedBox(
              width: 80.w,
              height: 80.w,
              child: Image.network(
                urls[index],
                fit: BoxFit.cover,
                loadingBuilder: (_, child, progress) => progress == null
                    ? child
                    : Container(color: context.colors.thirdBlue),
                errorBuilder: (_, __, ___) =>
                    Container(color: context.colors.thirdBlue),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
