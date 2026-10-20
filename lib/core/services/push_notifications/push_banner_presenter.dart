import 'dart:async';

import 'package:evetick/core/routing/app_navigator.dart';
import 'package:evetick/core/widgets/push_banner.dart';
import 'package:flutter/material.dart';

class PushBannerPresenter {
  static const Duration _visibleFor = Duration(seconds: 4);

  static OverlayEntry? _entry;
  static Timer? _timer;

  static void show({
    required String title,
    required String body,
    required VoidCallback onTap,
  }) {
    final overlay = appNavigatorKey.currentState?.overlay;
    if (overlay == null) return;

    dismiss();
    _entry = OverlayEntry(
      builder: (_) => PushBanner(
        title: title,
        body: body,
        onDismiss: dismiss,
        onTap: () {
          dismiss();
          onTap();
        },
      ),
    );
    overlay.insert(_entry!);
    _timer = Timer(_visibleFor, dismiss);
  }

  static void dismiss() {
    _timer?.cancel();
    _timer = null;
    _entry?.remove();
    _entry = null;
  }
}
