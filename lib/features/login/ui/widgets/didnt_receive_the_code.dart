import 'package:evetick/core/theming/styles.dart';
import 'package:flutter/material.dart';

class DidntReceiveTheCode extends StatelessWidget {
  const DidntReceiveTheCode({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyles.font12LightGrayRegular,
        children: [
          TextSpan(text: 'Didn\'t receive the code? '),
          TextSpan(
            text: 'Resend',
            style: TextStyles.font12OrangeBold,
            onEnter: (event) {},
          ),
        ],
      ),
    );
  }
}
