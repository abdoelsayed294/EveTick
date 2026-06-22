part of 'app_start_cubit.dart';

@freezed
class AppStartState with _$AppStartState {
  const factory AppStartState.initial() = _Initial;

  const factory AppStartState.loading() = _Loading;

  const factory AppStartState.goToOnboarding() = _GoToOnboarding;

  const factory AppStartState.goToLogin() = _GoToLogin;

  const factory AppStartState.goToHome() = _GoToHome;
}
