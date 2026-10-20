import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/widgets/app_error_view.dart';
import 'package:flutter/material.dart';

class EventDetailsErrorView extends StatelessWidget {
  const EventDetailsErrorView({super.key, this.message, this.onRetry});

  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: context.colors.white),
      ),
      body: AppErrorView(message: message, onRetry: onRetry),
    );
  }
}
