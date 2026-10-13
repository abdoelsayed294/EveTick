import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evetick/features/terms/data/models/terms_acceptance_model.dart';

class AppUserModel {
  final String uid;
  final String email;
  final String name;
  final bool isEmailVerified;
  final bool isGuest;
  final bool acceptedTerms;
  AppUserModel({
    required this.uid,
    required this.email,
    this.name = '',
    this.isEmailVerified = false,
    this.isGuest = false,
    this.acceptedTerms = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'isEmailVerified': isEmailVerified,
      'isGuest': isGuest,
      'createdAt': FieldValue.serverTimestamp(),
      if (acceptedTerms) ...TermsAcceptanceModel.acceptedFields(),
    };
  }

  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    return AppUserModel(
      uid: json['uid'],
      email: json['email'],
      name: json['name'],
      isEmailVerified: json['isEmailVerified'] ?? false,
      isGuest: json['isGuest'] ?? false,
      acceptedTerms: json['acceptedTerms'] ?? false,
    );
  }
}
