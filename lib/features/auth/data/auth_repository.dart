import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evetick/core/services/failure.dart';
import 'package:evetick/core/services/firebase_error_handler.dart';
import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/auth/data/models/app_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

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

  Future<AppUserModel?> getCurrentUser() async {
    final user = auth.currentUser;

    if (user == null) return null;

    return AppUserModel(uid: user.uid, email: user.email ?? '');
  }
}
