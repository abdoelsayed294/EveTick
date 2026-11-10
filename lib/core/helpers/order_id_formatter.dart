String formatOrderId(String orderId) {
  final short = orderId.length > 8 ? orderId.substring(0, 8) : orderId;
  return '#ET-${short.toUpperCase()}';
}
