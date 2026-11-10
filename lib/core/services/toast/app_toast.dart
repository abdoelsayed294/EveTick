import 'package:evetick/core/routing/app_navigator.dart';
import 'package:evetick/core/widgets/toast/toast_card.dart';
import 'package:evetick/core/widgets/toast/toast_type.dart';
import 'package:flutter/material.dart';


class AppToast {
  AppToast._();

  static const Duration _visibleFor = Duration(seconds: 3);

  static OverlayEntry? _entry;

  static void success(String message) => _show(ToastType.success, message);

  static void error(String message) => _show(ToastType.error, message);

  static void dismiss() {
    _entry?.remove();
    _entry = null;
  }

  static void _show(ToastType type, String message) {
    final overlay = appNavigatorKey.currentState?.overlay;
    if (overlay == null) return;

    dismiss();
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => ToastCard(
        type: type,
        message: message,
        duration: _visibleFor,
        onClosed: () {
          if (_entry == entry) dismiss();
        },
      ),
    );
    _entry = entry;
    overlay.insert(entry);
  }
}
