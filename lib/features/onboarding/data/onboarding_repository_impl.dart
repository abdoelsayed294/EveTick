import 'package:evetick/features/onboarding/domain/onboarding_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  String key = 'onboarding_Completed';
  @override
  Future<bool> isNew() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? true;
  }

  @override
  Future<void> notNew() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, false);
  }
}
