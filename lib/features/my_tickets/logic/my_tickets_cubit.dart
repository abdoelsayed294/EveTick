import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/my_tickets/data/my_tickets_repository.dart';
import 'package:evetick/features/my_tickets/logic/my_tickets_data.dart';
import 'package:evetick/features/my_tickets/logic/my_tickets_state.dart';
import 'package:evetick/features/my_tickets/logic/my_tickets_tab.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyTicketsCubit extends Cubit<MyTicketsState> {
  final MyTicketsRepository repo;

  MyTicketsCubit(this.repo) : super(const MyTicketsState.initial());

  MyTicketsData _data = const MyTicketsData();

  Future<void> load({bool silent = false}) async {
    if (!silent) emit(const MyTicketsState.loading());

    final result = await repo.getMyTickets();
    if (isClosed) return;
    result.when(
      success: (tickets) {
        _emitData(_data.copyWith(tickets: tickets));
      },
      failure: (failure) {
        if (silent && _data.tickets.isNotEmpty) return;
        emit(MyTicketsState.error(error: failure.message));
      },
    );
  }

  void selectTab(MyTicketsTab tab) => _emitData(_data.copyWith(tab: tab));

  void _emitData(MyTicketsData data) {
    _data = data;
    emit(MyTicketsState.success(_data));
  }
}
