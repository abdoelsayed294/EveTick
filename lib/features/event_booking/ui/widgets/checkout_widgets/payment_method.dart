import 'package:flutter/material.dart';

enum PaymentMethod {
  card('CARD', Icons.credit_card_rounded, 'Credit / Debit Card'),
  wallet('WALLET', Icons.account_balance_wallet_rounded, 'Mobile Wallet'),
  kiosk('KIOSK', Icons.store_rounded, 'Cash at Kiosk (Aman / Masary)');

  const PaymentMethod(this.apiValue, this.icon, this.label);

  final String apiValue;
  final IconData icon;
  final String label;
}
