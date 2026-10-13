import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/help_support/data/models/help_category.dart';
import 'package:evetick/features/help_support/data/support_repository.dart';
import 'package:evetick/features/help_support/logic/send_message/send_message_state.dart';
import 'package:evetick/features/help_support/logic/send_message/send_message_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendMessageCubit extends Cubit<SendMessageState> {
  final SupportRepository supportRepo;
  SendMessageCubit(this.supportRepo) : super(const SendMessageState());

  final formKey = GlobalKey<FormState>();
  final messageController = TextEditingController();

  void selectCategory(HelpCategory? category) {
    emit(state.copyWith(category: category, status: SendMessageStatus.idle));
  }

  Future<void> pickAttachment() async {
    final result = await supportRepo.pickAttachment();
    await result.when(
      success: (file) async {
        if (file == null) return;
        final isValid = await supportRepo.isValidAttachment(file);
        emit(
          isValid
              ? state.copyWith(attachment: file, status: SendMessageStatus.idle)
              : state.copyWith(status: SendMessageStatus.invalidAttachment),
        );
      },
      failure: (failure) async {
        emit(
          state.copyWith(
            status: SendMessageStatus.failure,
            error: failure.message,
          ),
        );
      },
    );
  }

  void removeAttachment() {
    emit(state.copyWith(clearAttachment: true, status: SendMessageStatus.idle));
  }

  Future<void> sendMessage() async {
    if (!formKey.currentState!.validate()) return;
    emit(state.copyWith(status: SendMessageStatus.sending));
    final result = await supportRepo.sendMessage(
      category: state.category!,
      message: messageController.text.trim(),
      attachment: state.attachment,
    );
    result.when(
      success: (_) => emit(state.copyWith(status: SendMessageStatus.sent)),
      failure: (failure) => emit(
        state.copyWith(
          status: SendMessageStatus.failure,
          error: failure.message,
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    messageController.dispose();
    return super.close();
  }
}
