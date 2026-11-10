import 'package:evetick/core/widgets/app_error_view.dart';
import 'package:evetick/features/home/logic/home_cubit.dart';
import 'package:evetick/features/home/logic/home_data.dart';
import 'package:evetick/features/home/logic/home_state.dart';
import 'package:evetick/features/home/ui/widgets/home_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBlocBuilder extends StatelessWidget {
  const HomeBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          current is Loading || current is Success || current is Error,
      builder: (context, state) {
        return state.maybeWhen(
          success: (data) => HomeContent(data: data as HomeData),
          error: (error) => AppErrorView(
            message: error,
            onRetry: () => context.read<HomeCubit>().load(),
          ),
          orElse: () => const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
