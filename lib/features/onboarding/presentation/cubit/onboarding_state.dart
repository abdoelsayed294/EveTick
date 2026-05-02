class OnboardingState {}

class OnboardingInitial extends OnboardingState {}

class UserIsNew extends OnboardingState {}

class UserIsNotNew extends OnboardingState {}

class OnboardingError extends OnboardingState {
  final String message;
  OnboardingError(this.message);
}