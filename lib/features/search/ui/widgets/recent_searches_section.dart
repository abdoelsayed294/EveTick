import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/features/search/ui/widgets/recent_search_tile.dart';
import 'package:flutter/material.dart';
import 'package:evetick/l10n/app_localizations.dart';

class RecentSearchesSection extends StatelessWidget {
  const RecentSearchesSection({
    super.key,
    required this.searches,
    required this.onSelected,
    required this.onClearAll,
  });

  final List<String> searches;
  final ValueChanged<String> onSelected;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context)!.searchRecentSearches, style: TextStyles.font18WhiteBold(context)),
            TextButton(
              onPressed: onClearAll,
              child: Text(AppLocalizations.of(context)!.searchClearAll, style: TextStyles.font12OrangeRegular),
            ),
          ],
        ),
        for (final search in searches)
          RecentSearchTile(text: search, onTap: () => onSelected(search)),
      ],
    );
  }
}
