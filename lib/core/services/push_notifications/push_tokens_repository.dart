import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';


class PushTokensRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>>? _tokens() {
    final user = auth.currentUser;
    if (user == null || user.isAnonymous) return null;
    return firestore.collection('users').doc(user.uid).collection('fcmTokens');
  }

  
  Future<bool> saveToken(String token) async {
    final tokens = _tokens();
    if (tokens == null) return false;
    try {
      await tokens.doc(token).set({
        'platform': defaultTargetPlatform.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      debugPrint('[PUSH] saveToken failed: $e');
      return false;
    }
  }

  Future<void> removeCurrentToken() async {
    try {
      final token = await FirebaseMessaging.instance
          .getToken()
          .timeout(const Duration(seconds: 3)); // never block the logout
      if (token == null) return;
      await _tokens()?.doc(token).delete();
    } catch (_) {}
  }
}
