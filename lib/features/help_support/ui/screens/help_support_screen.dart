import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/features/help_support/ui/widgets/help_category_grid.dart';
import 'package:evetick/features/help_support/ui/widgets/help_contact_card.dart';
import 'package:evetick/features/help_support/ui/widgets/help_faq_bloc_builder.dart';
import 'package:evetick/features/help_support/ui/widgets/help_search_field.dart';
import 'package:evetick/features/help_support/ui/widgets/help_support_app_bar.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: HelpSupportAppBar(title: l10n.helpSupportTitle),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HelpSearchField(),
              verticalSpace(24),
              Text(
                l10n.helpSupportCategories,
                style: TextStyles.font18WhiteBold(context),
              ),
              verticalSpace(16),
              const HelpCategoryGrid(),
              verticalSpace(24),
              const HelpFaqBlocBuilder(),
              verticalSpace(24),
              const HelpContactCard(),
            ],
          ),
        ),
      ),
    );
  }
}
