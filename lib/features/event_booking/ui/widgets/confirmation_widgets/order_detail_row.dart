import 'package:flutter/material.dart';

import 'package:evetick/core/theming/text_styles.dart';

class OrderDetailRow extends StatelessWidget {
  const OrderDetailRow({super.key, required this.label, required this.value});

  final String label;
  final Widget value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyles.font12LightGrayRegular(context)),
        value,
      ],
    );
  }
}
