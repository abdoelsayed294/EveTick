import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

enum HelpCategory {
  account(Icons.person_outline),
  booking(Icons.confirmation_number),
  payment(Icons.payments_outlined),
  organizerHelp(Icons.help);

  final IconData icon;
  const HelpCategory(this.icon);

  String label(AppLocalizations l10n) {
    return switch (this) {
      HelpCategory.account => l10n.helpSupportCategoriesAccount,
      HelpCategory.booking => l10n.helpSupportCategoriesBooking,
      HelpCategory.payment => l10n.helpSupportCategoriesPayment,
      HelpCategory.organizerHelp => l10n.helpSupportCategoriesOrganizerHelp,
    };
  }
}
