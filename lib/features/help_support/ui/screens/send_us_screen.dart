import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/features/help_support/logic/send_message/send_message_cubit.dart';
import 'package:evetick/features/help_support/ui/widgets/help_support_app_bar.dart';
import 'package:evetick/features/help_support/ui/widgets/send_message_bloc_listener.dart';
import 'package:evetick/features/help_support/ui/widgets/send_message_button.dart';
import 'package:evetick/features/help_support/ui/widgets/support_attachment_picker.dart';
import 'package:evetick/features/help_support/ui/widgets/support_category_dropdown.dart';
import 'package:evetick/features/help_support/ui/widgets/support_message_field.dart';
import 'package:evetick/features/help_support/ui/widgets/support_response_note.dart';
import 'package:evetick/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SendUsScreen extends StatelessWidget {
  const SendUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SendMessageBlocListener(
      child: Scaffold(
        appBar: HelpSupportAppBar(
          title: AppLocalizations.of(context)!.helpSupportSendMessageTitle,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  child: Form(
                    key: context.read<SendMessageCubit>().formKey,
                    child: Column(
                      children: [
                        const SupportCategoryDropdown(),
                        verticalSpace(24),
                        const SupportMessageField(),
                        verticalSpace(24),
                        const SupportAttachmentPicker(),
                        verticalSpace(24),
                        const SupportResponseNote(),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                child: const SendMessageButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
