import 'package:firebase_auth/firebase_auth.dart';

import 'failure.dart';

class FirebaseErrorHandler {
  static FirebaseFailure handle(
    FirebaseAuthException e,
  ) {
    switch (e.code) {
      case 'invalid-credential':
  return FirebaseFailure('Invalid email or password');

case 'too-many-requests':
  return FirebaseFailure('Too many attempts, try again later');

case 'network-request-failed':
  return FirebaseFailure('No internet connection');

default:
  return FirebaseFailure('Error code: ${e.code} | ${e.message}');

    }
  }
}