import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:evetick/core/services/firebase_failure.dart';

class FirebaseErrorHandler {
  static FirebaseFailure handle(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-credential':
        return FirebaseFailure('Invalid email or password');

      case 'user-not-found':
        return FirebaseFailure('No account found with this email');

      case 'wrong-password':
        return FirebaseFailure('Incorrect password');

      case 'user-disabled':
        return FirebaseFailure('This account has been disabled');
      
      case 'email-already-in-use':
        return FirebaseFailure('This email is already registered');

      case 'weak-password':
        return FirebaseFailure('Password is too weak, use a stronger one');

      case 'invalid-email':
        return FirebaseFailure('Invalid email format');

      case 'operation-not-allowed':
        return FirebaseFailure('This sign-in method is not enabled');

      case 'too-many-requests':
        return FirebaseFailure('Too many attempts, try again later');

      case 'network-request-failed':
        return FirebaseFailure('No internet connection');

      case 'user-token-expired':
        return FirebaseFailure('Session expired, please login again');

      case 'requires-recent-login':
        return FirebaseFailure('Please sign in again to continue');

      case 'account-exists-with-different-credential':
        return FirebaseFailure(
          'An account already exists with this email using a different sign-in method',
        );


      default:
        return FirebaseFailure('Error code: ${e.code} | ${e.message}');
    }
  }

  static FirebaseFailure handleGoogleSignIn(GoogleSignInException e) {
    switch (e.code) {
      case GoogleSignInExceptionCode.clientConfigurationError:
      case GoogleSignInExceptionCode.providerConfigurationError:
        return FirebaseFailure('Google sign-in is not configured correctly');

      case GoogleSignInExceptionCode.uiUnavailable:
        return FirebaseFailure('Google sign-in is not available right now');

      default:
        return FirebaseFailure('Google sign-in failed, please try again');
    }
  }

  static FirebaseFailure handleGeneric(Object e) {
    return FirebaseFailure('Something went wrong, please try again');
  }
  
  static FirebaseFailure handleFirestore(FirebaseException e) {
  switch (e.code) {
    case 'permission-denied':
      return FirebaseFailure('Permission denied');

    case 'unavailable':
      return FirebaseFailure('Service unavailable');

    case 'not-found':
      return FirebaseFailure('Data not found');

    default:
      return FirebaseFailure(
        'Firestore Error: ${e.code}',
      );
  }
}

static FirebaseFailure notFound(String message) {
  return FirebaseFailure(message);
}


static FirebaseFailure handleStorage(FirebaseException e) {
  switch (e.code) {
    case 'object-not-found':
      return FirebaseFailure('File not found');

    case 'unauthorized':
      return FirebaseFailure('Unauthorized');

    case 'canceled':
      return FirebaseFailure('Upload cancelled');

    case 'unknown':
      return FirebaseFailure('Unknown storage error');

    default:
      return FirebaseFailure(e.message ?? 'Storage Error');
  }
}
}
