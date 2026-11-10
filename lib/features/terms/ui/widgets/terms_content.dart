import 'package:evetick/features/terms/ui/widgets/terms_body_text.dart';
import 'package:evetick/features/terms/ui/widgets/terms_header.dart';
import 'package:evetick/features/terms/ui/widgets/terms_prohibited_item.dart';
import 'package:evetick/features/terms/ui/widgets/terms_refund_note.dart';
import 'package:evetick/features/terms/ui/widgets/terms_section.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class TermsContent extends StatelessWidget {
  const TermsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TermsHeader(),
        TermsSection(
          number: 1,
          title: l10n.termsSectionsAcceptanceTitle,
          children: [
            TermsBodyText(l10n.termsSectionsAcceptanceBody1),
            TermsBodyText(l10n.termsSectionsAcceptanceBody2),
          ],
        ),
        TermsSection(
          number: 2,
          title: l10n.termsSectionsEligibilityTitle,
          children: [
            TermsBodyText(l10n.termsSectionsEligibilityBody),
            TermsBodyText(l10n.termsSectionsEligibilityListItem1),
            TermsBodyText(l10n.termsSectionsEligibilityListItem2),
            TermsBodyText(l10n.termsSectionsEligibilityListItem3),
          ],
        ),
        TermsSection(
          number: 3,
          title: l10n.termsSectionsTicketPurchaseTitle,
          children: [
            TermsBodyText(l10n.termsSectionsTicketPurchaseSummary),
            const TermsRefundNote(),
          ],
        ),
        TermsSection(
          number: 4,
          title: l10n.termsSectionsProhibitedConductTitle,
          children: [
            TermsBodyText(l10n.termsSectionsProhibitedConductIntro),
            TermsProhibitedItem(
              icon: Icons.block,
              text: l10n.termsSectionsProhibitedConductListItem1,
            ),
            TermsProhibitedItem(
              icon: Icons.gpp_bad,
              text: l10n.termsSectionsProhibitedConductListItem2,
            ),
            TermsProhibitedItem(
              icon: Icons.person_off_outlined,
              text: l10n.termsSectionsProhibitedConductListItem3,
            ),
          ],
        ),
        TermsSection(
          number: 5,
          title: l10n.termsSectionsIpTitle,
          children: [TermsBodyText(l10n.termsSectionsIpBody)],
        ),
        TermsSection(
          number: 6,
          title: l10n.termsSectionsLiabilityTitle,
          children: [TermsBodyText(l10n.termsSectionsLiabilityBody)],
        ),
      ],
    );
  }
}
