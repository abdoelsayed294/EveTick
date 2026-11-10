import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/widgets/toast/toast_type.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';


extension ToastTypeStyle on ToastType {
  Color get color => switch (this) {
        ToastType.success => ColorsManager.confirmed,
        ToastType.error => ColorsManager.red,
      };

  IconData get icon => switch (this) {
        ToastType.success => Icons.check_circle_rounded,
        ToastType.error => Icons.error_rounded,
      };

  String title(AppLocalizations l10n) => switch (this) {
        ToastType.success => l10n.toastSuccessTitle,
        ToastType.error => l10n.toastErrorTitle,
      };
}
