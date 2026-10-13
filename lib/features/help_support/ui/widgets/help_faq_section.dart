import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/features/help_support/data/models/help_faq_model.dart';
import 'package:evetick/features/help_support/logic/help_cubit.dart';
import 'package:evetick/features/help_support/logic/help_state.dart';
import 'package:evetick/features/help_support/ui/widgets/help_faq_item.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HelpFaqSection extends StatelessWidget {
  const HelpFaqSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final faqs = [
      HelpFaqModel(
        question: l10n.helpSupportFaqRefundQuestion,
        answer: l10n.helpSupportFaqRefundAnswer,
      ),
      HelpFaqModel(
        question: l10n.helpSupportFaqQrCodeQuestion,
        answer: l10n.helpSupportFaqQrCodeAnswer,
      ),
      HelpFaqModel(
        question: l10n.helpSupportFaqTransferQuestion,
        answer: l10n.helpSupportFaqTransferAnswer,
      ),
      HelpFaqModel(
        question: l10n.helpSupportFaqProfilePhotoQuestion,
        answer: l10n.helpSupportFaqProfilePhotoAnswer,
      ),
    ];

    return BlocBuilder<HelpCubit, HelpState>(
      builder: (context, state) {
        final visible = faqs.where((faq) => faq.matches(state.query)).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.helpSupportFrequentQuestions,
              style: TextStyles.font18WhiteBold(context),
            ),
            verticalSpace(8),
            if (visible.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  l10n.helpSupportNoResults,
                  style: TextStyles.font14LightGrayRegular(context),
                ),
              ),
            for (var i = 0; i < visible.length; i++)
              HelpFaqItem(
                faq: visible[i],
                isExpanded: state.expandedIndex == i,
                onTap: () => context.read<HelpCubit>().toggleFaq(i),
              ),
          ],
        );
      },
    );
  }
}
