import 'package:bloc/bloc.dart';
import 'package:evetick/features/auth/data/auth_repository.dart';
import 'package:evetick/features/onboarding/domain/onboarding_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_start_state.dart';
part 'app_start_cubit.freezed.dart';

class AppStartCubit extends Cubit<AppStartState> {
  final AuthRepository authRepository;
  final OnboardingRepository onboardingRepository;
  AppStartCubit({
    required this.authRepository,
    required this.onboardingRepository,
  }) : super(AppStartState.initial());
  void checkAppStart() async {
    emit(AppStartState.loading());

    final isOnboardingCompleted = await onboardingRepository
        .hasSeenOnboarding();

    if (!isOnboardingCompleted) {
      emit(AppStartState.goToOnboarding());
      return;
    }

    final user = await authRepository.getCurrentUser();

    if (user == null) {
      emit(AppStartState.goToLogin());
      return;
    }

    emit(AppStartState.goToHome());
  }
}
