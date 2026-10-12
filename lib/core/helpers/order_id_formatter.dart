/// Short, readable version of a Firestore order id: "#ET-AB12CD34".
/// (The full id is still what's stored and encoded in the QR code.)
String formatOrderId(String orderId) {
  final short = orderId.length > 8 ? orderId.substring(0, 8) : orderId;
  return '#ET-${short.toUpperCase()}';
}
