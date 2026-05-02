import 'package:bloc/bloc.dart';
import 'package:evetick/features/onboarding/domain/onboarding_repository.dart';
import 'package:evetick/features/onboarding/presentation/cubit/onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingRepository onboardingRepository;
  OnboardingCubit(this.onboardingRepository) : super(OnboardingInitial()) {
    onboardingRepository.isNew();
  }
  Future<void> isNew() async {
    try {
      final isNew = await onboardingRepository.isNew();
      if (isNew) {
        emit(UserIsNew());
      } else {
        emit(UserIsNotNew());
      }
    } catch (e) {
      emit(OnboardingError(e.toString()));
    }
  }

  Future<void> notNew() async {
    try {
      await onboardingRepository.notNew();
      emit(UserIsNotNew());
    } catch (e) {
      emit(OnboardingError(e.toString()));
    }
  }
}