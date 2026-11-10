import 'package:json_annotation/json_annotation.dart';

part 'ticket_tier_model.g.dart';

@JsonSerializable()
class TicketTier {
  @JsonKey(name: 'ticketName')
  final String name;
  @JsonKey(name: 'ticketDescription')
  final String description;
  @JsonKey(name: 'ticketPrice')
  final double price;
  @JsonKey(name: 'ticketQuantity')
  final int quantity;
  TicketTier({
      required this.name,
      required this.description,
      required this.price,
      required this.quantity,
  });

  factory TicketTier.fromJson(Map<String, dynamic> json) =>
      _$TicketTierFromJson(json);
    
  Map<String, dynamic> toJson() => _$TicketTierToJson(this);
}
