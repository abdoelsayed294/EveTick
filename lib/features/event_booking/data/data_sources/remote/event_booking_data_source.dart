import 'package:evetick/core/services/result.dart';
import 'package:evetick/features/event_booking/data/models/event_model.dart';
import 'package:evetick/features/event_booking/data/models/order_model.dart';
import 'package:evetick/features/event_booking/data/models/payment_session.dart';
import 'package:evetick/features/event_booking/data/models/seating_config_model.dart';
import 'package:evetick/features/event_booking/data/models/ticket_model.dart';

abstract class EventBookingDataSource {
  Future<Result<EventModel>> getEvent(String eventId);

  Future<Result<List<TicketTier>>> getTicketTier(String eventId);

  Future<Result<SeatingConfig>> getSeatingConfig(String eventId);

  /// Creates the order and reserves seats / decreases ticket stock
  /// in one transaction. Returns the new order id.
  Future<Result<String>> placeOrder(OrderModel order);

  /// Asks the `createPayment` Cloud Function to reserve seats / stock and
  /// open a Paymob payment. The order stays `pending` until Paymob confirms.
  Future<Result<PaymentSession>> createPayment(OrderModel order);

  /// Live `status` of `orders/{orderId}` ("pending", "confirmed", ...).
  Stream<String> watchOrderStatus(String orderId);

  Future<Result<TicketModel>> getOrder(String orderId);
}
