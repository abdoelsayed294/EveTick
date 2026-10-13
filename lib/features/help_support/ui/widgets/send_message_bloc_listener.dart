import 'package:evetick/core/helpers/extentions.dart';
import 'package:evetick/features/help_support/logic/send_message/send_message_cubit.dart';
import 'package:evetick/features/help_support/logic/send_message/send_message_state.dart';
import 'package:evetick/features/help_support/logic/send_message/send_message_status.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendMessageBlocListener extends StatelessWidget {
  final Widget child;

  const SendMessageBlocListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SendMessageCubit, SendMessageState>(
      listenWhen: (previous, current) =>
          current.status == SendMessageStatus.sent ||
          current.status == SendMessageStatus.failure ||
          current.status == SendMessageStatus.invalidAttachment,
      listener: (context, state) {
        final l10n = AppLocalizations.of(context)!;
        final messenger = ScaffoldMessenger.of(context);

        switch (state.status) {
          case SendMessageStatus.sent:
            messenger.showSnackBar(
              SnackBar(
                content: Text(l10n.helpSupportMessageSent),
                backgroundColor: Colors.green,
              ),
            );
            context.pop();
          case SendMessageStatus.failure:
            messenger.showSnackBar(
              SnackBar(
                content: Text(state.error ?? ''),
                backgroundColor: Colors.red,
              ),
            );
          case SendMessageStatus.invalidAttachment:
            messenger.showSnackBar(
              SnackBar(
                content: Text(l10n.helpSupportAttachmentInvalid),
                backgroundColor: Colors.red,
              ),
            );
          case SendMessageStatus.idle || SendMessageStatus.sending:
            break;
        }
      },
      child: child,
    );
  }
}
