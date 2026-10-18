/// Answer of the `createPayment` Cloud Function.
class PaymentSession {
  const PaymentSession({
    required this.orderId,
    required this.clientSecret,
    required this.amount,
  });

  final String orderId;
  final String clientSecret;

  /// Total in EGP (tickets + service fee + taxes), computed by the server.
  final double amount;

  factory PaymentSession.fromJson(Map<String, dynamic> json) {
    return PaymentSession(
      orderId: json['orderId'] as String,
      clientSecret: json['clientSecret'] as String,
      amount: (json['amount'] as num).toDouble(),
    );
  }
}
