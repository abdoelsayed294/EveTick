import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evetick/core/services/firebase_error_handler.dart';
import 'package:evetick/core/services/push_notifications/push_tokens_repository.dart';
import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/auth/data/models/app_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:evetick/core/services/cancelled_failure.dart';
import 'package:evetick/core/services/firebase_failure.dart';
import 'package:evetick/core/services/failure.dart';

class AuthRepository {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool _googleInitialized = false;

  Future<Result<AppUserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final firebaseUser = userCredential.user!;

      await firebaseUser.reload();
      final refreshedUser = auth.currentUser!;

      if (!refreshedUser.emailVerified) {
        await auth.signOut();
        return Result.failure(
          FirebaseFailure('Please verify your email before logging in'),
        );
      }
      final docRef = firestore.collection('users').doc(refreshedUser.uid);
      final doc = await firestore
          .collection('users')
          .doc(refreshedUser.uid)
          .get();

      if (!doc.exists) {
        await auth.signOut();
        return Result.failure(FirebaseFailure('User data not found'));
      }

      final data = doc.data()!;
      if (data['isEmailVerified'] != true) {
        await docRef.update({'isEmailVerified': true});
        data['isEmailVerified'] = true;
      }

      final user = AppUserModel.fromJson(doc.data()!);

      return Result.success(user);
    } on FirebaseAuthException catch (e) {
      return Result.failure(FirebaseErrorHandler.handle(e));
    } catch (e) {
      return Result.failure(FirebaseErrorHandler.handleGeneric(e));
    }
  }

  Future<Result<AppUserModel>> signup({
    required String name,
    required String email,
    required String password,
    required bool acceptedTerms,
  }) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await userCredential.user!.updateDisplayName(name.trim());

      await userCredential.user!.sendEmailVerification();

      AppUserModel user = AppUserModel(
        uid: userCredential.user!.uid,
        email: email.trim(),
        name: name.trim(),
        isEmailVerified: false,
        isGuest: false,
        acceptedTerms: acceptedTerms,
      );
      await firestore.collection('users').doc(user.uid).set(user.toJson());

      await auth.signOut();

      return Result.success(user);
    } on FirebaseAuthException catch (e) {
      return Result.failure(FirebaseErrorHandler.handle(e));
    } catch (e) {
      return Result.failure(FirebaseErrorHandler.handleGeneric(e));
    }
  }

  Future<Result<AppUserModel>> signInWithGoogle() async {
    try {
      if (!_googleInitialized) {
        await GoogleSignIn.instance.initialize();
        _googleInitialized = true;
      }

      final googleUser = await GoogleSignIn.instance.authenticate();
      final idToken = googleUser.authentication.idToken;

      if (idToken == null) {
        return Result.failure(
          FirebaseFailure('Google sign-in failed, please try again'),
        );
      }

      final userCredential = await auth.signInWithCredential(
        GoogleAuthProvider.credential(idToken: idToken),
      );
      final firebaseUser = userCredential.user!;

      final docRef = firestore.collection('users').doc(firebaseUser.uid);
      final doc = await docRef.get();

      if (!doc.exists) {
        final user = AppUserModel(
          uid: firebaseUser.uid,
          email: firebaseUser.email ?? googleUser.email,
          name: (firebaseUser.displayName ?? googleUser.displayName ?? '')
              .trim(),
          isEmailVerified: true,
          isGuest: false,
        );
        await docRef.set(user.toJson());
        return Result.success(user);
      }

      final data = doc.data()!;
      if (data['isEmailVerified'] != true) {
        await docRef.update({'isEmailVerified': true});
        data['isEmailVerified'] = true;
      }

      return Result.success(AppUserModel.fromJson(data));
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return Result.failure(CancelledFailure());
      }
      return Result.failure(FirebaseErrorHandler.handleGoogleSignIn(e));
    } on FirebaseAuthException catch (e) {
      return Result.failure(FirebaseErrorHandler.handle(e));
    } catch (e) {
      return Result.failure(FirebaseErrorHandler.handleGeneric(e));
    }
  }

  Future<AppUserModel?> getCurrentUser() async {
    final firebaseUser = auth.currentUser;

    if (firebaseUser == null) return null;

    final doc = await firestore.collection('users').doc(firebaseUser.uid).get();

    if (!doc.exists) return null;

    return AppUserModel.fromJson(doc.data()!);
  }

  Future<Result<AppUserModel>> continueAsGuest() async {
    try {
      final credential = await auth.signInAnonymously();

      final user = AppUserModel(
        uid: credential.user!.uid,
        email: '',
        name: 'Guest',
        isEmailVerified: false,
        isGuest: true,
      );

      final docRef = firestore.collection('users').doc(user.uid);
      final doc = await docRef.get();

      if (!doc.exists) {
        await docRef.set(user.toJson());
      }

      return Result.success(user);
    } on FirebaseAuthException catch (e) {
      return Result.failure(FirebaseErrorHandler.handle(e));
    } catch (e) {
      return Result.failure(FirebaseErrorHandler.handleGeneric(e));
    }
  }

  bool get requiresPassword =>
      auth.currentUser?.providerData.any((p) => p.providerId == 'password') ??
      false;

  bool get usesGoogle =>
      auth.currentUser?.providerData.any(
        (p) => p.providerId == 'google.com',
      ) ??
      false;

  Future<Result<String>> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await auth.sendPasswordResetEmail(email: email.trim());
      return Result.success(email.trim());
    } on FirebaseAuthException catch (e) {
      return Result.failure(FirebaseErrorHandler.handle(e));
    } catch (e) {
      return Result.failure(FirebaseErrorHandler.handleGeneric(e));
    }
  }

  Future<Result<void>> deleteAccount({String? password}) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        return Result.failure(FirebaseFailure('No user is signed in'));
      }

      final reauthFailure = await _reauthenticate(user, password);
      if (reauthFailure != null) return Result.failure(reauthFailure);

      await PushTokensRepository().removeCurrentToken();
      await _deleteUserData(user.uid);
      await user.delete();

      if (_googleInitialized) {
        await GoogleSignIn.instance.signOut();
      }
      return Result.success(null);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return Result.failure(CancelledFailure());
      }
      return Result.failure(FirebaseErrorHandler.handleGoogleSignIn(e));
    } on FirebaseAuthException catch (e) {
      if (requiresPassword &&
          (e.code == 'wrong-password' || e.code == 'invalid-credential')) {
        return Result.failure(FirebaseFailure('Incorrect password'));
      }
      return Result.failure(FirebaseErrorHandler.handle(e));
    } on FirebaseException catch (e) {
      return Result.failure(FirebaseErrorHandler.handleFirestore(e));
    } catch (e) {
      return Result.failure(FirebaseErrorHandler.handleGeneric(e));
    }
  }

  Future<Failure?> _reauthenticate(User user, String? password) async {
    final providers = user.providerData.map((p) => p.providerId).toList();

    if (providers.contains('password')) {
      if (password == null || password.isEmpty) {
        return FirebaseFailure('Please enter your password');
      }
      await user.reauthenticateWithCredential(
        EmailAuthProvider.credential(email: user.email!, password: password),
      );
      return null;
    }

    if (providers.contains('google.com')) {
      if (!_googleInitialized) {
        await GoogleSignIn.instance.initialize();
        _googleInitialized = true;
      }
      final googleUser = await GoogleSignIn.instance.authenticate();
      final idToken = googleUser.authentication.idToken;
      if (idToken == null) {
        return FirebaseFailure('Google sign-in failed, please try again');
      }
      await user.reauthenticateWithCredential(
        GoogleAuthProvider.credential(idToken: idToken),
      );
    }
    return null;
  }

  Future<void> _deleteUserData(String uid) async {
    final userRef = firestore.collection('users').doc(uid);
    await _deleteCollection(userRef.collection('fcmTokens'));
    await _deleteCollection(userRef.collection('notifications'));
    await _deleteCollection(userRef.collection('following'));
    await userRef.delete();
  }

  Future<void> _deleteCollection(
    CollectionReference<Map<String, dynamic>> collection,
  ) async {
    while (true) {
      final snapshot = await collection.limit(400).get();
      if (snapshot.docs.isEmpty) return;
      final batch = firestore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }
  }

  Future<void> logout() async {
    await PushTokensRepository().removeCurrentToken();
    await auth.signOut();
    if (_googleInitialized) {
      await GoogleSignIn.instance.signOut();
    }
  }
}
