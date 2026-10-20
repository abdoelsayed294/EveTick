// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_tier_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketTier _$TicketTierFromJson(Map<String, dynamic> json) => TicketTier(
  name: json['ticketName'] as String,
  description: json['ticketDescription'] as String,
  price: (json['ticketPrice'] as num).toDouble(),
  quantity: (json['ticketQuantity'] as num).toInt(),
);

Map<String, dynamic> _$TicketTierToJson(TicketTier instance) =>
    <String, dynamic>{
      'ticketName': instance.name,
      'ticketDescription': instance.description,
      'ticketPrice': instance.price,
      'ticketQuantity': instance.quantity,
    };
