import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evetick/core/services/failure.dart';
import 'package:evetick/core/services/firebase_error_handler.dart';
import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/help_support/data/models/help_category.dart';
import 'package:evetick/features/help_support/data/models/support_message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class SupportRepository {
  static const int maxAttachmentBytes = 5 * 1024 * 1024;
  static const List<String> allowedExtensions = ['png', 'jpg', 'jpeg'];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  /// Returns `null` when the user cancels the picker.
  Future<Result<File?>> pickAttachment() async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return Result.success(null);
      return Result.success(File(image.path));
    } catch (e) {
      return Result.failure(FirebaseErrorHandler.handleGeneric(e));
    }
  }

  Future<bool> isValidAttachment(File file) async {
    final extension = file.path.split('.').last.toLowerCase();
    if (!allowedExtensions.contains(extension)) return false;
    return await file.length() <= maxAttachmentBytes;
  }

  Future<Result<void>> sendMessage({
    required HelpCategory category,
    required String message,
    File? attachment,
  }) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        return Result.failure(FirebaseFailure('User is not logged in'));
      }

      String? attachmentUrl;
      if (attachment != null) {
        final extension = attachment.path.split('.').last.toLowerCase();
        final ref = storage.ref().child(
          'support_attachments/${user.uid}/'
          '${DateTime.now().millisecondsSinceEpoch}.$extension',
        );
        await ref.putFile(attachment);
        attachmentUrl = await ref.getDownloadURL();
      }

      final model = SupportMessageModel(
        uid: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
        category: category.name,
        message: message,
        attachmentUrl: attachmentUrl,
      );
      await firestore.collection('support_messages').add(model.toJson());
      return Result.success(null);
    } on FirebaseException catch (e) {
      return Result.failure(
        e.plugin == 'firebase_storage'
            ? FirebaseErrorHandler.handleStorage(e)
            : FirebaseErrorHandler.handleFirestore(e),
      );
    } catch (e) {
      return Result.failure(FirebaseErrorHandler.handleGeneric(e));
    }
  }
}
