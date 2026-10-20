import 'package:evetick/features/my_tickets/data/models/my_ticket_model.dart';
import 'package:evetick/features/my_tickets/data/models/ticket_phase.dart';
import 'package:evetick/features/my_tickets/logic/my_tickets_tab.dart';

class MyTicketsData {
  const MyTicketsData({
    this.tickets = const [],
    this.tab = MyTicketsTab.upcoming,
  });

  final List<MyTicket> tickets;
  final MyTicketsTab tab;

  List<MyTicket> get visibleTickets {
    final now = DateTime.now();
    final isPast = tab == MyTicketsTab.past;
    final list = tickets
        .where((t) => (t.phase(now) == TicketPhase.past) == isPast)
        .toList();
    return isPast ? list.reversed.toList() : list;
  }

  MyTicketsData copyWith({List<MyTicket>? tickets, MyTicketsTab? tab}) {
    return MyTicketsData(
      tickets: tickets ?? this.tickets,
      tab: tab ?? this.tab,
    );
  }
}
