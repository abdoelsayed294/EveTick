import 'package:evetick/features/event_booking/data/models/order_pricing.dart';
import 'package:evetick/features/event_booking/data/models/order_ticket_item.dart';
import 'package:evetick/features/event_booking/data/models/order_seat.dart';

class OrderModel {
  const OrderModel({
    required this.eventId,
    required this.eventTitle,
    required this.eventCoverImageUrl,
    required this.eventStartAt,
    required this.eventEndAt,
    required this.eventCategory,
    this.eventLocation,
    required this.tickets,
    required this.seats,
    required this.paymentMethod,
  });

  final String eventId;
  final String eventTitle;
  final String eventCoverImageUrl;
  final String eventStartAt;
  final String eventEndAt;
  final String eventCategory;
  final String? eventLocation;
  final List<OrderTicketItem> tickets;
  final List<OrderSeat> seats;
  final String paymentMethod;

  int get ticketCount => tickets.fold(0, (sum, t) => sum + t.quantity);

  double get subtotal =>
      tickets.fold(0.0, (sum, t) => sum + t.price * t.quantity);

  OrderPricing get pricing => OrderPricing(subtotal);

  Map<String, dynamic> toPaymentRequest() => {
        'eventId': eventId,
        'paymentMethod': paymentMethod,
        'tickets': tickets
            .map((t) => {'tierIndex': t.tierIndex, 'quantity': t.quantity})
            .toList(),
        'seats': seats
            .map((s) => {'rowIndex': s.rowIndex, 'seatIndex': s.seatIndex})
            .toList(),
      };

  Map<String, dynamic> toMap({
    required String orderId,
    required String userId,
    String? attendeeName,
    Map<int, String> sectionByTier = const {},
  }) {
    return {
      'orderId': orderId,
      'userId': userId,
      'eventId': eventId,
      'eventTitle': eventTitle,
      'eventCoverImageUrl': eventCoverImageUrl,
      'eventStartAt': eventStartAt,
      'eventEndAt': eventEndAt,
      'eventCategory': eventCategory,
      'attendeeName': attendeeName,
      'eventLocation': eventLocation,
      'tickets': tickets
          .map((t) => t.toMap(sectionName: sectionByTier[t.tierIndex]))
          .toList(),
      'seats': seats.map((s) => s.toMap()).toList(),
      'ticketCount': ticketCount,
      'subtotal': subtotal,
      'serviceFee': pricing.serviceFee,
      'taxes': pricing.taxes,
      'totalPrice': pricing.total,
      'paymentMethod': paymentMethod,
      'status': 'confirmed',
    };
  }
}
