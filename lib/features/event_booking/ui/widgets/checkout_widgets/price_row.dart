import 'package:evetick/core/theming/text_styles.dart';
import 'package:flutter/material.dart';

class PriceRow extends StatelessWidget {
  const PriceRow({required this.label, required this.amount});

  final String label;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyles.font16LightGrayRegular(context)),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyles.font16WhiteRegular(context),
        ),
      ],
    );
  }
}