import 'package:evetick/features/event_booking/data/models/ticket_model.dart';

enum TicketStatus { loading, success, error }

class TicketState {
  const TicketState({
    this.status = TicketStatus.loading,
    this.ticket,
    this.errorMessage,
  });

  final TicketStatus status;
  final TicketModel? ticket;
  final String? errorMessage;
}
