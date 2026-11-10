import 'package:evetick/core/widgets/app_error_view.dart';
import 'package:evetick/features/my_tickets/logic/my_tickets_cubit.dart';
import 'package:evetick/features/my_tickets/logic/my_tickets_data.dart';
import 'package:evetick/features/my_tickets/logic/my_tickets_state.dart';
import 'package:evetick/features/my_tickets/ui/widgets/my_tickets_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyTicketsBlocBuilder extends StatelessWidget {
  const MyTicketsBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyTicketsCubit, MyTicketsState>(
      buildWhen: (previous, current) =>
          current is Loading || current is Success || current is Error,
      builder: (context, state) {
        return state.maybeWhen(
          success: (data) => MyTicketsContent(data: data as MyTicketsData),
          error: (error) => AppErrorView(
            message: error,
            onRetry: context.read<MyTicketsCubit>().load,
          ),
          orElse: () => const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
