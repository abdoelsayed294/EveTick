import 'dart:io';

import 'package:evetick/features/help_support/data/models/help_category.dart';
import 'package:evetick/features/help_support/logic/send_message/send_message_status.dart';

class SendMessageState {
  final HelpCategory? category;
  final File? attachment;
  final SendMessageStatus status;
  final String? error;

  const SendMessageState({
    this.category,
    this.attachment,
    this.status = SendMessageStatus.idle,
    this.error,
  });

  SendMessageState copyWith({
    HelpCategory? category,
    File? attachment,
    bool clearAttachment = false,
    SendMessageStatus? status,
    String? error,
  }) {
    return SendMessageState(
      category: category ?? this.category,
      attachment: clearAttachment ? null : attachment ?? this.attachment,
      status: status ?? this.status,
      error: error,
    );
  }
}
