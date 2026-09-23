// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventModel _$EventModelFromJson(Map<String, dynamic> json) => EventModel(
  id: json['eventId'] as String,
  title: json['eventTitle'] as String,
  coverImageUrl: json['coverImageUrl'] as String,
  category: json['eventCategory'] as String,
  description: json['eventDescription'] as String,
  location: json['eventLocation'] as String?,
  endAt: json['endAt'] as String,
  startAt: json['startAt'] as String,
  isOnline: json['isOnlineEvent'] as bool,
  galleryImagesUrls: (json['galleryImagesUrls'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  ticketTiers: (json['ticketTiers'] as List<dynamic>)
      .map((e) => TicketTier.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$EventModelToJson(EventModel instance) =>
    <String, dynamic>{
      'eventId': instance.id,
      'eventTitle': instance.title,
      'coverImageUrl': instance.coverImageUrl,
      'eventCategory': instance.category,
      'eventDescription': instance.description,
      'eventLocation': instance.location,
      'endAt': instance.endAt,
      'startAt': instance.startAt,
      'isOnlineEvent': instance.isOnline,
      'galleryImagesUrls': instance.galleryImagesUrls,
      'ticketTiers': instance.ticketTiers,
    };

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
