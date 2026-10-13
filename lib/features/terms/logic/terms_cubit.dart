import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/terms/data/terms_repository.dart';
import 'package:evetick/features/terms/logic/terms_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TermsCubit extends Cubit<TermsState> {
  final TermsRepository termsRepo;
  TermsCubit(this.termsRepo) : super(const TermsState.initial());

  Future<void> loadAcceptance() async {
    emit(const TermsState.loading());
    final result = await termsRepo.getAcceptance();
    result.when(
      success: (acceptance) => emit(TermsState.loaded(acceptance)),
      failure: (failure) => emit(TermsState.error(error: failure.message)),
    );
  }

  Future<void> acceptTerms() async {
    emit(const TermsState.saving());
    final result = await termsRepo.acceptTerms();
    result.when(
      success: (_) => emit(const TermsState.saved()),
      failure: (failure) => emit(TermsState.error(error: failure.message)),
    );
  }
}
