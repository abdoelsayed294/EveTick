import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/event_booking/data/data_sources/remote/event_booking_data_source.dart';
import 'package:evetick/features/event_booking/data/models/event_model.dart';

class EventBookingRepo {
  final EventBookingDataSource dataSource;

  EventBookingRepo(this.dataSource);

  Future<Result<List<TicketTier>>> getTicketTier(String eventId) {
    return dataSource.getTicketTier(eventId);
  }
}