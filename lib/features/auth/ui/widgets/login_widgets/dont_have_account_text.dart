import 'package:evetick/core/theming/styles.dart';
import 'package:flutter/material.dart';

class DontHaveAccountText extends StatelessWidget {
  const DontHaveAccountText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Don\'t have an account? ',
            style: TextStyles.font12LightGrayRegular
          ),
          TextSpan(
            text: 'Sign Up',
            style: TextStyles.font12OrangeMid
          )
        ]
      )
      );
  }
}