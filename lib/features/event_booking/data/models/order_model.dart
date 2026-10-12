/// Fees applied on top of the tickets subtotal.
/// Change the rates here only; the checkout screen and the saved order
/// both use this class.
class OrderPricing {
  const OrderPricing(this.subtotal);

  static const double serviceFeeRate = 0.10;
  static const double taxRate = 0.05;

  final double subtotal;

  double get serviceFee => _round(subtotal * serviceFeeRate);
  double get taxes => _round(subtotal * taxRate);
  double get total => _round(subtotal + serviceFee + taxes);

  static double _round(double v) => (v * 100).roundToDouble() / 100;
}

class OrderTicketItem {
  const OrderTicketItem({
    required this.tierIndex,
    required this.name,
    required this.price,
    required this.quantity,
  });

  /// Position of the tier inside `events/{id}.ticketTiers`
  /// (used to decrease the stock, not saved in the order).
  final int tierIndex;
  final String name;
  final double price;
  final int quantity;

  Map<String, dynamic> toMap() => {
        'ticketName': name,
        'ticketPrice': price,
        'quantity': quantity,
      };
}

class OrderSeat {
  const OrderSeat({
    required this.rowIndex,
    required this.seatIndex,
    required this.label,
  });

  /// Position inside `seatingConfig.seatMap[rowIndex].seats[seatIndex]`.
  final int rowIndex;
  final int seatIndex;
  final String label;

  Map<String, dynamic> toMap() => {
        'row': rowIndex,
        'seat': seatIndex,
        'label': label,
      };
}

/// What the app sends to create an order.
/// `orders/{orderId}`:
/// {
///   orderId, userId, eventId, eventTitle, eventCoverImageUrl,
///   eventStartAt, eventEndAt, eventCategory, eventLocation, attendeeName,
///   tickets: [...], seats: [...],
///   ticketCount, subtotal, serviceFee, taxes, totalPrice,
///   paymentMethod, status: "confirmed", createdAt
/// }
/// Card details are never stored.
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

  Map<String, dynamic> toMap({
    required String orderId,
    required String userId,
    String? attendeeName,
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
      'tickets': tickets.map((t) => t.toMap()).toList(),
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
