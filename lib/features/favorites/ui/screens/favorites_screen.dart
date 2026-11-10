import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/features/favorites/ui/widgets/favorites_bloc_builder.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              verticalSpace(30),
              Text(
                AppLocalizations.of(context)!.favoritesTitle,
                style: TextStyles.font18WhiteBold(context),
              ),
              verticalSpace(16),
              const Expanded(child: FavoritesBlocBuilder()),
            ],
          ),
        ),
      ),
    );
  }
}
