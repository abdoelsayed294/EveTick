abstract class OnboardingRepository {
  Future<bool> isNew();
  Future<void> notNew();
}