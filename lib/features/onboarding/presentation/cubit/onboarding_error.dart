import 'package:evetick/features/onboarding/presentation/cubit/onboarding_state.dart';

class OnboardingError extends OnboardingState {
  final String message;
  OnboardingError(this.message);
}
