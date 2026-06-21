import 'package:cloud_firestore/cloud_firestore.dart';

class AppUserModel {
  String uid;
  String email;
  String name;
  final bool isEmailVerified;

  AppUserModel({
    required this.uid,
    required this.email,
    this.name = '',
    this.isEmailVerified = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'isEmailVerified': isEmailVerified,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    return AppUserModel(
      uid: json['uid'],
      email: json['email'],
      name: json['name'],
      isEmailVerified: json['isEmailVerified'] ?? false,
    );
  }
}
