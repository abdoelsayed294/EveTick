import 'package:evetick/core/di/dependency_injection.dart';
import 'package:evetick/core/routing/app_router.dart';
import 'package:evetick/evetick_app.dart';
import 'package:evetick/features/app_start/logic/cubit/app_start_cubit.dart';
import 'package:evetick/features/auth/data/auth_repository.dart';
import 'package:evetick/features/onboarding/data/onboarding_repository_impl.dart';
import 'package:evetick/features/onboarding/domain/onboarding_repository.dart';
import 'package:evetick/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:evetick/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  setupGetIt();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppStartCubit>(
          create: (context) => AppStartCubit(
            authRepository: getIt<AuthRepository>(),
            onboardingRepository: getIt<OnboardingRepository>(),
          )..checkAppStart(),
        ),
        BlocProvider<OnboardingCubit>(
          create: (context) => OnboardingCubit(OnboardingRepositoryImpl()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: EvetickApp(appRouter: AppRouter()),
      ),
    );
  }
}
