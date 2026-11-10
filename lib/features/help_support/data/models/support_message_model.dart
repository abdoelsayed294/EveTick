import 'package:cloud_firestore/cloud_firestore.dart';

class SupportMessageModel {
  final String uid;
  final String name;
  final String email;
  final String category;
  final String message;
  final String? attachmentUrl;

  const SupportMessageModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.category,
    required this.message,
    this.attachmentUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'category': category,
      'message': message,
      'attachmentUrl': attachmentUrl,
      'status': 'open',
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
