class OrderSeat {
  const OrderSeat({
    required this.rowIndex,
    required this.seatIndex,
    required this.label,
  });

  final int rowIndex;
  final int seatIndex;
  final String label;

  Map<String, dynamic> toMap() => {
        'row': rowIndex,
        'seat': seatIndex,
        'label': label,
      };
}
