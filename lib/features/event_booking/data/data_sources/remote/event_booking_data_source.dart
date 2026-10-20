import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/event_booking/data/models/event_model.dart';
import 'package:evetick/features/event_booking/data/models/order_model.dart';
import 'package:evetick/features/event_booking/data/models/payment_session.dart';
import 'package:evetick/features/event_booking/data/models/seating_config_model.dart';
import 'package:evetick/features/event_booking/data/models/ticket_model.dart';
import 'package:evetick/features/event_booking/data/models/ticket_tier_model.dart';

abstract class EventBookingDataSource {
  Future<Result<EventModel>> getEvent(String eventId);

  Future<Result<List<TicketTier>>> getTicketTier(String eventId);

  Future<Result<SeatingConfig>> getSeatingConfig(String eventId);

  Future<Result<String>> placeOrder(OrderModel order);

  Future<Result<PaymentSession>> createPayment(OrderModel order);

  Stream<String> watchOrderStatus(String orderId);

  Future<Result<TicketModel>> getOrder(String orderId);
}
