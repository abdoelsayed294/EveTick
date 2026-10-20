import 'package:evetick/core/helpers/spacing.dart';
import 'package:evetick/features/my_tickets/logic/my_tickets_cubit.dart';
import 'package:evetick/features/my_tickets/logic/my_tickets_data.dart';
import 'package:evetick/features/my_tickets/ui/widgets/my_tickets_list.dart';
import 'package:evetick/features/my_tickets/ui/widgets/my_tickets_tab_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyTicketsContent extends StatelessWidget {
  const MyTicketsContent({super.key, required this.data});

  final MyTicketsData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyTicketsTabSwitch(
          selected: data.tab,
          onSelected: context.read<MyTicketsCubit>().selectTab,
        ),
        verticalSpace(16),
        Expanded(child: MyTicketsList(data: data)),
      ],
    );
  }
}
