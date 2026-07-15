import 'package:evetick/core/di/dependency_injection.dart';
import 'package:evetick/core/routing/app_router.dart';
import 'package:evetick/evetick_app.dart';
import 'package:evetick/features/localization/logic/locale_cubit.dart';
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
    return BlocProvider(
      create: (context) =>  getIt<LocaleCubit>()..loadLocale(),
      child: EvetickApp(appRouter: AppRouter()),
    );
  }
}
