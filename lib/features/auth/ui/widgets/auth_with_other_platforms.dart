import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/features/auth/logic/login_cubit/login_cubit.dart';
import 'package:evetick/features/auth/ui/widgets/or_devider.dart';
import 'package:evetick/features/auth/ui/widgets/platform_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginWithOtherPlatforms extends StatelessWidget {
  const LoginWithOtherPlatforms({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OrDevider(),
        verticalSpace(24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => context.read<LoginCubit>().signInWithGoogle(),
              child: PlatformContainer(url: 'assets/svgs/google.svg'),
            ),
          ],
        ),
      ],
    );
  }
}
