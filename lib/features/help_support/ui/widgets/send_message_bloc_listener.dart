import 'package:evetick/core/helpers/extentions.dart';
import 'package:evetick/core/services/toast/app_toast.dart';
import 'package:evetick/features/help_support/logic/send_message/send_message_cubit.dart';
import 'package:evetick/features/help_support/logic/send_message/send_message_state.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendMessageBlocListener extends StatelessWidget {
  final Widget child;

  const SendMessageBlocListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SendMessageCubit, SendMessageState>(
      listenWhen: (previous, current) => current is Success || current is Error,
      listener: (context, state) {
        final l10n = AppLocalizations.of(context)!;

        state.whenOrNull(
          success: (data) {
            AppToast.success(l10n.helpSupportMessageSent);
            context.pop();
          },
          error: (error) {
            AppToast.error(
              error == SendMessageCubit.invalidAttachmentError
                  ? l10n.helpSupportAttachmentInvalid
                  : error,
            );
          },
        );
      },
      child: child,
    );
  }
}
