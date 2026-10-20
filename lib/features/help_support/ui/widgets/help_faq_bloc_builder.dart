import 'package:evetick/features/help_support/logic/help_cubit.dart';
import 'package:evetick/features/help_support/logic/help_data.dart';
import 'package:evetick/features/help_support/logic/help_state.dart';
import 'package:evetick/features/help_support/ui/widgets/help_faq_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HelpFaqBlocBuilder extends StatelessWidget {
  const HelpFaqBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HelpCubit, HelpState>(
      buildWhen: (previous, current) => current is Success,
      builder: (context, state) {
        return state.maybeWhen(
          success: (data) => HelpFaqSection(data: data as HelpData),
          orElse: () => const SizedBox.shrink(),
        );
      },
    );
  }
}
