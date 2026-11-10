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
