import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:evetick/core/services/cancelled_failure.dart';
import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/auth/data/auth_repository.dart';
import 'package:evetick/features/auth/logic/delete_account_cubit/delete_account_state.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  final AuthRepository authRepo;
  DeleteAccountCubit(this.authRepo) : super(const DeleteAccountState.initial());

  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool get requiresPassword => authRepo.requiresPassword;
  bool get usesGoogle => authRepo.usesGoogle;

  void emitDeleteAccountStates({String? password}) async {
    if (state is Loading) return;
    emit(const DeleteAccountState.loading());
    final result = await authRepo.deleteAccount(password: password);
    if (isClosed) return;
    result.when(
      success: (_) {
        emit(const DeleteAccountState.success(true));
      },
      failure: (failure) {
        if (failure is CancelledFailure) {
          emit(const DeleteAccountState.initial());
          return;
        }
        emit(DeleteAccountState.error(error: failure.message));
      },
    );
  }

  @override
  Future<void> close() {
    passwordController.dispose();
    return super.close();
  }
}
