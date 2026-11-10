import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PushBanner extends StatelessWidget {
  const PushBanner({
    super.key,
    required this.title,
    required this.body,
    required this.onTap,
    required this.onDismiss,
  });

  final String title;
  final String body;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
          child: GestureDetector(
            onTap: onTap,
            onVerticalDragEnd: (details) {
              if ((details.primaryVelocity ?? 0) < 0) onDismiss();
            },
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: context.colors.lightBlue,
                  borderRadius: BorderRadius.circular(16.r),
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
                    Icon(
                      Icons.notifications_rounded,
                      color: ColorsManager.orange,
                      size: 24.sp,
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
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: context.colors.white,
                            ),
                          ),
                          if (body.isNotEmpty) ...[
                            verticalSpace(4),
                            Text(
                              body,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13.sp,
                                height: 1.4,
                                color: context.colors.lightGray,
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
    );
  }
}
