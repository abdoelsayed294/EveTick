import 'package:evetick/features/home/ui/widgets/home_bloc_builder.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        bottom: false,
        child: HomeBlocBuilder(),
      ),
    );
  }
}
