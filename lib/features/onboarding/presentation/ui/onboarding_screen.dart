import 'package:evetick/core/routing/routes.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:evetick/features/onboarding/presentation/ui/onboarding1_screen.dart';
import 'package:evetick/features/onboarding/presentation/ui/onboarding2_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0;
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        currentIndex = pageController.page!.round();
      });
    });
    context.read<OnboardingCubit>().isNew();
  }

  void _goToNext() {
    if (currentIndex < 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, Routes.loginScreen);
    }
  }

  void _skip() {
    Navigator.pushReplacementNamed(context, Routes.loginScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.darkBlue,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              onPageChanged: (value) {
                setState(() {
                  currentIndex = value;
                });
              },
              controller: pageController,
              children: [
                Onboarding1Screen(
                  currentIndex: currentIndex,
                  onNext: _goToNext,
                  onSkip: _skip,
                ),
                Onboarding2Screen(
                  currentIndex: currentIndex,
                  onNext: _goToNext,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
