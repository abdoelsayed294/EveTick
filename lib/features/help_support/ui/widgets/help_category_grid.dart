import 'package:evetick/features/help_support/data/models/help_category.dart';
import 'package:evetick/features/help_support/ui/widgets/help_category_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HelpCategoryGrid extends StatelessWidget {
  const HelpCategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16.h,
      crossAxisSpacing: 16.w,
      childAspectRatio: 163 / 122,
      children: [
        for (final category in HelpCategory.values)
          HelpCategoryTile(category: category),
      ],
    );
  }
}
