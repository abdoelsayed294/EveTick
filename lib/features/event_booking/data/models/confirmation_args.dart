import 'package:evetick/core/helpers/order_id_formatter.dart';

/// Data the confirmation screen needs (passed as route arguments).
class ConfirmationArgs {
  const ConfirmationArgs({
    required this.orderId,
    required this.eventTitle,
    required this.totalPaid,
    required this.paidAt,
    required this.coverImageUrl,
    this.location,
  });

  final String orderId;
  final String eventTitle;
  final double totalPaid;
  final DateTime paidAt;
  final String coverImageUrl;
  final String? location;

  String get displayOrderId => formatOrderId(orderId);
}
