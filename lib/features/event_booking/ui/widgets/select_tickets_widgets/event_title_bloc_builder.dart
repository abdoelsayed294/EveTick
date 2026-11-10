import 'package:evetick/core/theming/text_styles.dart';
import 'package:evetick/features/event_booking/logic/checkout/checkout_cubit.dart';
import 'package:evetick/features/event_booking/logic/checkout/checkout_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventTitleBlocBuilder extends StatelessWidget {
  const EventTitleBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutCubit, CheckoutState>(
      builder: (context, state) {
        final title = state.maybeMap(
          success: (s) => s.event.title,
          orElse: () => '',
        );

        return Text(title, style: TextStyles.font18WhiteBold(context));
      },
    );
  }
}
