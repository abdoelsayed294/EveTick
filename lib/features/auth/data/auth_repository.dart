
import 'package:evetick/core/services/firebase_error_handler.dart';
import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/auth/data/models/app_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth auth = FirebaseAuth.instance;

 Future<Result<AppUserModel>> login({
  required String email,
  required String password,
}) async {
  try {
    UserCredential userCredential = await auth.signInWithEmailAndPassword(
      email: email.trim(),  
      password: password.trim(),  
    );
    AppUserModel user = AppUserModel(
      uid: userCredential.user!.uid,
      email: email,
    );
    return Result.success(user);
  }  on FirebaseAuthException catch (e) {
    return Result.failure(FirebaseErrorHandler.handle(e));
  }
}
}
