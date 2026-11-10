import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evetick/features/terms/data/terms_constants.dart';

class TermsAcceptanceModel {
  final bool accepted;
  final String? version;
  final DateTime? acceptedAt;

  const TermsAcceptanceModel({
    this.accepted = false,
    this.version,
    this.acceptedAt,
  });

  bool get isUpToDate => accepted && version == TermsConstants.version;

  factory TermsAcceptanceModel.fromJson(Map<String, dynamic> json) {
    return TermsAcceptanceModel(
      accepted: json['acceptedTerms'] == true,
      version: json['termsVersion'] as String?,
      acceptedAt: (json['termsAcceptedAt'] as Timestamp?)?.toDate(),
    );
  }

  static Map<String, dynamic> acceptedFields() {
    return {
      'acceptedTerms': true,
      'termsVersion': TermsConstants.version,
      'termsAcceptedAt': FieldValue.serverTimestamp(),
    };
  }
}
