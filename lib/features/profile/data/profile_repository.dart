import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evetick/core/services/failure.dart';
import 'package:evetick/core/services/firebase_error_handler.dart';
import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/profile/data/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<Result<UserModel>> getUserData() async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        return Result.failure(FirebaseFailure('User is not logged in'));
      }
      final doc = await firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) {
        return Result.failure(FirebaseFailure('User data not found'));
      }
      final userdata = UserModel.fromJson(doc.data()!, user.uid);
      return Result.success(userdata);
    } on FirebaseException catch (e) {
      return Result.failure(FirebaseErrorHandler.handleFirestore(e));
    } catch (e) {
      return Result.failure(FirebaseErrorHandler.handleGeneric(e));
    }
  }
}
