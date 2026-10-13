import 'package:evetick/features/my_tickets/data/models/my_ticket_model.dart';

enum MyTicketsStatus { loading, success, error }

enum MyTicketsTab { upcoming, past }

class MyTicketsState {
  const MyTicketsState({
    this.status = MyTicketsStatus.loading,
    this.errorMessage,
    this.tickets = const [],
    this.tab = MyTicketsTab.upcoming,
  });

  final MyTicketsStatus status;
  final String? errorMessage;
  final List<MyTicket> tickets;
  final MyTicketsTab tab;

  /// Tickets of the selected tab. Upcoming: soonest first.
  /// Past: most recent first.
  List<MyTicket> get visibleTickets {
    final now = DateTime.now();
    final isPast = tab == MyTicketsTab.past;
    final list = tickets
        .where((t) => (t.phase(now) == TicketPhase.past) == isPast)
        .toList();
    return isPast ? list.reversed.toList() : list;
  }

  MyTicketsState copyWith({
    MyTicketsStatus? status,
    String? errorMessage,
    List<MyTicket>? tickets,
    MyTicketsTab? tab,
  }) {
    return MyTicketsState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      tickets: tickets ?? this.tickets,
      tab: tab ?? this.tab,
    );
  }
}
