import 'package:evetick/core/di/dependency_injection.dart';
import 'package:evetick/core/routing/app_router.dart';
import 'package:evetick/core/services/supabaseKeys.dart';
import 'package:evetick/evetick_app.dart';
import 'package:evetick/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
   await Supabase.initialize(
    url: SupabaseKeys.url,
    publishableKey: SupabaseKeys.anonKey,
  );

  setupGetIt();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return EvetickApp(appRouter: AppRouter());
  }
}
