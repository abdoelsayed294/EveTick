import 'dart:io';

import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/help_support/data/models/help_category.dart';
import 'package:evetick/features/help_support/data/support_repository.dart';
import 'package:evetick/features/help_support/logic/send_message/send_message_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendMessageCubit extends Cubit<SendMessageState> {
  final SupportRepository supportRepo;
  SendMessageCubit(this.supportRepo) : super(const SendMessageState.initial());

  static const invalidAttachmentError = 'invalid_attachment';

  final formKey = GlobalKey<FormState>();
  final messageController = TextEditingController();

  final category = ValueNotifier<HelpCategory?>(null);
  final attachment = ValueNotifier<File?>(null);

  void selectCategory(HelpCategory? value) => category.value = value;

  Future<void> pickAttachment() async {
    emit(const SendMessageState.initial());

    final result = await supportRepo.pickAttachment();
    await result.when(
      success: (file) async {
        if (file == null) return;
        if (!await supportRepo.isValidAttachment(file)) {
          emit(const SendMessageState.error(error: invalidAttachmentError));
          return;
        }
        attachment.value = file;
      },
      failure: (failure) async {
        emit(SendMessageState.error(error: failure.message));
      },
    );
  }

  void removeAttachment() => attachment.value = null;

  Future<void> sendMessage() async {
    if (!formKey.currentState!.validate()) return;

    emit(const SendMessageState.loading());
    final result = await supportRepo.sendMessage(
      category: category.value!,
      message: messageController.text.trim(),
      attachment: attachment.value,
    );
    if (isClosed) return;
    result.when(
      success: (_) {
        emit(const SendMessageState.success(null));
      },
      failure: (failure) {
        emit(SendMessageState.error(error: failure.message));
      },
    );
  }

  @override
  Future<void> close() {
    messageController.dispose();
    category.dispose();
    attachment.dispose();
    return super.close();
  }
}
