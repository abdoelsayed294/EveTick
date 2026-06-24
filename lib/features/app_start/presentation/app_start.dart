import 'package:evetick/core/routing/routes.dart';
import 'package:evetick/features/app_start/logic/cubit/app_start_cubit.dart';
import 'package:evetick/features/app_start/logic/cubit/app_start_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:evetick/core/helpers/extentions.dart';

class AppStartScreen extends StatelessWidget {
  const AppStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppStartCubit, AppStartState>(
      listener: (context, state) {
        state.when(
          initial: () {},
          loading: () {},
          goToOnboarding: () {
            context.pushReplacedNamed(Routes.onBoardingScreen);
          },
          goToLogin: () {
            context.pushReplacedNamed(Routes.loginScreen);
          },
          goToHome: () {
            context.pushReplacedNamed(Routes.homeScreen);
          },
          goToLocation: () {
            context.pushReplacedNamed(Routes.setLocationScreen);
          },
        );
      },
      child: const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
