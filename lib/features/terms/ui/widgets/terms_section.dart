import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:flutter/material.dart';

class TermsSection extends StatelessWidget {
  final int number;
  final String title;
  final List<Widget> children;

  const TermsSection({
    super.key,
    required this.number,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        verticalSpace(24),
        Text('$number. $title', style: TextStyles.font18WhiteBold(context)),
        verticalSpace(12),
        for (final child in children) ...[child, verticalSpace(12)],
      ],
    );
  }
}
