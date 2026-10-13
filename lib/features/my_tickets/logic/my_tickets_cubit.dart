import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/my_tickets/data/my_tickets_repository.dart';
import 'package:evetick/features/my_tickets/logic/my_tickets_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyTicketsCubit extends Cubit<MyTicketsState> {
  final MyTicketsRepository repo;

  MyTicketsCubit(this.repo) : super(const MyTicketsState());

  /// [silent] keeps the current list on screen (pull to refresh, tab opened).
  Future<void> load({bool silent = false}) async {
    if (!silent) emit(state.copyWith(status: MyTicketsStatus.loading));

    final result = await repo.getMyTickets();
    result.when(
      success: (tickets) => emit(
        state.copyWith(status: MyTicketsStatus.success, tickets: tickets),
      ),
      failure: (error) {
        // On a silent refresh keep what the user already sees.
        if (silent && state.tickets.isNotEmpty) return;
        emit(
          state.copyWith(
            status: MyTicketsStatus.error,
            errorMessage: error.message,
          ),
        );
      },
    );
  }

  void selectTab(MyTicketsTab tab) => emit(state.copyWith(tab: tab));
}
