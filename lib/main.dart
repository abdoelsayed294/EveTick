
import 'package:evetick/features/auth/presentation/screens/Done_screen.dart';
import 'package:evetick/features/auth/presentation/screens/verify_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DoneScreen(),
    );
  }
}
