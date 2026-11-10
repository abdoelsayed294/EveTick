class OrderTicketItem {
  const OrderTicketItem({
    required this.tierIndex,
    required this.name,
    required this.price,
    required this.quantity,
  });

  final int tierIndex;
  final String name;
  final double price;
  final int quantity;

  Map<String, dynamic> toMap({String? sectionName}) => {
        'ticketName': name,
        'ticketPrice': price,
        'quantity': quantity,
        if (sectionName != null) 'sectionName': sectionName,
      };
}
