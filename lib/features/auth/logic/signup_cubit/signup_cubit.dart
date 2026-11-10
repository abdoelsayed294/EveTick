import 'package:evetick/features/auth/logic/signup_cubit/signup_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:evetick/features/auth/data/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:evetick/core/services/result.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepository authRepo;
  SignupCubit(this.authRepo) : super(const SignupState.initial());

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final acceptedTerms = ValueNotifier<bool>(false);
  final showTermsError = ValueNotifier<bool>(false);

  void setTermsAccepted(bool value) {
    acceptedTerms.value = value;
    if (value) showTermsError.value = false;
  }

  bool validateTerms() {
    showTermsError.value = !acceptedTerms.value;
    return acceptedTerms.value;
  }

  void emitSignupStates({
    required String name,
    required String email,
    required String password,
  }) async {
    if (!acceptedTerms.value) return;
    emit(const SignupState.loading());
    final result = await authRepo.signup(
      name: name,
      email: email,
      password: password,
      acceptedTerms: acceptedTerms.value,
    );
    result.when(
      success: (user) {
        emit(SignupState.success(user));
      },
      failure: (failure) {
        emit(SignupState.error(error: failure.message));
      },
    );
  }

  @override
  Future<void> close() {
    acceptedTerms.dispose();
    showTermsError.dispose();
    return super.close();
  }
}
