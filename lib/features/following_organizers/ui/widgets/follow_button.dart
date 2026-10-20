import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:evetick/l10n/app_localizations.dart';

/// "Follow" (orange, filled) / "Following" (outlined).
/// Shared by the organizer page and the following list.
class FollowButton extends StatelessWidget {
  const FollowButton({
    super.key,
    required this.isFollowing,
    required this.onPressed,
    this.width,
    this.height,
  });

  final bool isFollowing;
  final VoidCallback onPressed;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final white = context.colors.white;
    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r));
    final label = Text(
      isFollowing ? AppLocalizations.of(context)!.commonFollowing : AppLocalizations.of(context)!.commonFollow,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: white,
      ),
    );

    return SizedBox(
      width: width ?? 100.w,
      height: height ?? 40.h,
      child: isFollowing
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                shape: shape,
                padding: EdgeInsets.zero,
                side: BorderSide(color: white.withValues(alpha: 0.6)),
              ),
              child: label,
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                shape: shape,
                padding: EdgeInsets.zero,
                elevation: 0,
                backgroundColor: ColorsManager.orange,
              ),
              child: label,
            ),
    );
  }
}
