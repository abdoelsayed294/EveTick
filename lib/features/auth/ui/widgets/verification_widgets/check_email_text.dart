import 'package:evetick/core/theming/styles.dart';
import 'package:flutter/material.dart';

class CheckEmailText extends StatelessWidget {
  const CheckEmailText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyles.font12LightGrayRegular.copyWith(
                  height: 1.45
                ),
                children: [
                  TextSpan(
                    text: 'Check your email for the code sent \n'
                    ),
                    TextSpan(
                      text: 'to '
                    ),
                    TextSpan(
                      text: 'hello@evetick.com',
                      style: TextStyles.font12OrangeBold
                    )
                ]      
              )
              );
  }
}