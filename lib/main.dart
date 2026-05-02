import 'package:evetick/core/routing/app_router.dart';
import 'package:evetick/evetick_app.dart';
import 'package:evetick/features/onboarding/data/onboarding_repository_impl.dart';
import 'package:evetick/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
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
