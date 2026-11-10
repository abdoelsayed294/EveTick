import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/event_booking/data/data_sources/remote/event_booking_data_source.dart';
import 'package:evetick/features/event_booking/data/models/event_model.dart';
import 'package:evetick/features/event_booking/data/models/order_model.dart';
import 'package:evetick/features/event_booking/data/models/payment_session.dart';
import 'package:evetick/features/event_booking/data/models/seating_config_model.dart';
import 'package:evetick/features/event_booking/data/models/ticket_model.dart';
import 'package:evetick/features/event_booking/data/models/ticket_tier_model.dart';

class EventBookingRepo {
  final EventBookingDataSource dataSource;

  EventBookingRepo(this.dataSource);

  Future<Result<EventModel>> getEvent(String eventId) {
    return dataSource.getEvent(eventId);
  }

  Future<Result<List<TicketTier>>> getTicketTier(String eventId) {
    return dataSource.getTicketTier(eventId);
  }

  Future<Result<SeatingConfig>> getSeatingConfig(String eventId) {
    return dataSource.getSeatingConfig(eventId);
  }

  Future<Result<String>> placeOrder(OrderModel order) {
    return dataSource.placeOrder(order);
  }

  Future<Result<PaymentSession>> createPayment(OrderModel order) {
    return dataSource.createPayment(order);
  }

  Stream<String> watchOrderStatus(String orderId) {
    return dataSource.watchOrderStatus(orderId);
  }

  Future<Result<TicketModel>> getOrder(String orderId) {
    return dataSource.getOrder(orderId);
  }
}
