import 'package:evetick/core/helpers/extentions.dart';
import 'package:evetick/core/routing/routes.dart';
import 'package:evetick/core/theming/colors.dart';
import 'package:evetick/features/auth/logic/signup_cubit/signup_cubit.dart';
import 'package:evetick/features/auth/logic/signup_cubit/signup_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupBlocListener extends StatelessWidget {
  const SignupBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupCubit, SignupState>(
      listenWhen: (previous, current) =>
          current is Loading || current is Success || current is Error,
      listener: (context, state) {
        state.whenOrNull(
          loading: () {
            showDialog(
              context: context,
              builder: (context) => const Center(
                child: CircularProgressIndicator(color: ColorsManager.orange),
              ),
            );
          },
          success: (data) {
            context.pop();
            context.pushNamed(Routes.loginScreen);
          },
          error: (error) {
            setupErrorState(context, error);
            print(error);
          },
        );
      },
      child: const SizedBox.shrink(),
    );
  }

  void setupErrorState(BuildContext context, String error) {
    context.pop();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        icon: const Icon(Icons.error, color: ColorsManager.red, size: 32),
        content: Text(
          error,
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
            },
            child: const Text('Got it', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
    print(error);
  }
}
