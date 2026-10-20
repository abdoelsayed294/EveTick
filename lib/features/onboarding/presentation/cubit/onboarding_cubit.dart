import 'package:bloc/bloc.dart';
import 'package:evetick/features/onboarding/domain/onboarding_repository.dart';
import 'package:evetick/features/onboarding/presentation/cubit/onboarding_state.dart';
import 'package:evetick/features/onboarding/presentation/cubit/onboarding_initial.dart';
import 'package:evetick/features/onboarding/presentation/cubit/onboarding_finished.dart';
import 'package:evetick/features/onboarding/presentation/cubit/onboarding_error.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final OnboardingRepository onboardingRepository;

  OnboardingCubit(this.onboardingRepository) : super(OnboardingInitial());

  Future<void> finishOnboarding() async {
    try {
      await onboardingRepository.markOnboardingAsSeen();
      emit(OnboardingFinished());
    } catch (e) {
      emit(OnboardingError(e.toString()));
    }
  }
}
