import 'package:evetick/core/theming/extensions/build_context_extension.dart';
import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/core/widgets/app_text_form_field.dart';
import 'package:evetick/features/help_support/logic/send_message/send_message_cubit.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SupportMessageField extends StatelessWidget {
  const SupportMessageField({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppTextFormField(
      label: l10n.helpSupportYourMessageLabel,
      hintText: l10n.helpSupportMessagePlaceholder,
      hintStyle: TextStyles.font14LightGrayRegular(context),
      backgroundColor: context.colors.lightBlue,
      maxLines: 6,
      keyboardType: TextInputType.multiline,
      controller: context.read<SendMessageCubit>().messageController,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return l10n.helpSupportMessageRequired;
        }
        return null;
      },
    );
  }
}
