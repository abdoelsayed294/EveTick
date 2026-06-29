import 'package:evetick/features/onboarding/presentation/widgets/image_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeImage extends StatelessWidget {
  const WelcomeImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: 650.h,
          child: Image.asset(
            'assets/images/welcome_background_image.png',
            fit: BoxFit.cover,
          ),
        ),
        ImageGradient(),
      ],
    );
  }
}
