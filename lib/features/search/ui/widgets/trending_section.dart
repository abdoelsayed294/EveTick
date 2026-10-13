import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/features/search/ui/widgets/search_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TrendingSection extends StatelessWidget {
  const TrendingSection({
    super.key,
    required this.titles,
    required this.onSelected,
  });

  final List<String> titles;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Trending Now', style: TextStyles.font18WhiteBold(context)),
        verticalSpace(12),
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: [
            for (final title in titles)
              SearchChip(
                label: title,
                backgroundColor: context.colors.lightBlue,
                onTap: () => onSelected(title),
              ),
          ],
        ),
      ],
    );
  }
}
