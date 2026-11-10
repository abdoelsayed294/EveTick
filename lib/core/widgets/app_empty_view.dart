import 'package:evetick/core/theming/text_styles.dart';
import 'package:flutter/material.dart';

class AppEmptyView extends StatelessWidget {
  const AppEmptyView({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message, style: TextStyles.font16LightGrayRegular(context)),
    );
  }
}
