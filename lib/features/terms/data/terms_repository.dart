import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evetick/core/services/failure.dart';
import 'package:evetick/core/services/firebase_error_handler.dart';
import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/terms/data/models/terms_acceptance_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TermsRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<Result<TermsAcceptanceModel>> getAcceptance() async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        return Result.failure(FirebaseFailure('User is not logged in'));
      }
      final doc = await firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) {
        return Result.failure(FirebaseFailure('User data not found'));
      }
      return Result.success(TermsAcceptanceModel.fromJson(doc.data()!));
    } on FirebaseException catch (e) {
      return Result.failure(FirebaseErrorHandler.handleFirestore(e));
    } catch (e) {
      return Result.failure(FirebaseErrorHandler.handleGeneric(e));
    }
  }

  Future<Result<void>> acceptTerms() async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        return Result.failure(FirebaseFailure('User is not logged in'));
      }
      await firestore
          .collection('users')
          .doc(user.uid)
          .update(TermsAcceptanceModel.acceptedFields());
      return Result.success(null);
    } on FirebaseException catch (e) {
      return Result.failure(FirebaseErrorHandler.handleFirestore(e));
    } catch (e) {
      return Result.failure(FirebaseErrorHandler.handleGeneric(e));
    }
  }
}
