import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/core/widgets/filled_app_text_button.dart';
import 'package:evetick/features/help_support/logic/send_message/send_message_cubit.dart';
import 'package:evetick/features/help_support/logic/send_message/send_message_state.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SendMessageButton extends StatelessWidget {
  const SendMessageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SendMessageCubit, SendMessageState>(
      buildWhen: (previous, current) =>
          current is Loading || previous is Loading,
      builder: (context, state) {
        return state.maybeWhen(
          loading: () => SizedBox(
            height: 48.h,
            child: Center(
              child: CircularProgressIndicator(color: ColorsManager.orange),
            ),
          ),
          orElse: () => FilledAppTextButton(
            buttonText: AppLocalizations.of(context)!.helpSupportSendMessage,
            onPressed: context.read<SendMessageCubit>().sendMessage,
          ),
        );
      },
    );
  }
}
