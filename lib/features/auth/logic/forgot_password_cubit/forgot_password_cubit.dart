import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/auth/data/auth_repository.dart';
import 'package:evetick/features/auth/logic/forgot_password_cubit/forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthRepository authRepo;
  ForgotPasswordCubit(this.authRepo)
    : super(const ForgotPasswordState.initial());

  TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void prefillEmail(String email) {
    emailController.text = email.trim();
  }

  void emitForgotPasswordStates({required String email}) async {
    if (state is Loading) return;
    emit(const ForgotPasswordState.loading());
    final result = await authRepo.sendPasswordResetEmail(email: email);
    if (isClosed) return;
    result.when(
      success: (email) {
        emit(ForgotPasswordState.success(email));
      },
      failure: (failure) {
        emit(ForgotPasswordState.error(error: failure.message));
      },
    );
  }

  @override
  Future<void> close() {
    emailController.dispose();
    return super.close();
  }
}
