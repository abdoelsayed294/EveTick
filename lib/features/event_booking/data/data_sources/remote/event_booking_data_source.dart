import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/event_booking/data/models/event_model.dart';

abstract class EventBookingDataSource {
  Future<Result<List<TicketTier>>> getTicketTier(String eventId);
}