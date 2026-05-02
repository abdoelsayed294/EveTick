import 'package:evetick/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageGradient extends StatelessWidget {
  const ImageGradient({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: const [0.11, 0.5, 0.84],
            colors: [
              ColorsManager.darkBlue.withValues(alpha: 0.97),
              ColorsManager.darkBlue.withValues(alpha: 0.5),
              ColorsManager.darkBlue.withValues(alpha: 0.97),
            ],
          ),
        ),
      ),
    );
  }
}
