
import 'package:json_annotation/json_annotation.dart';
import 'package:evetick/features/event_booking/data/models/ticket_tier_model.dart';

part 'event_model.g.dart';

@JsonSerializable()
class EventModel {
  @JsonKey(name: 'eventId')
  final String id;
  @JsonKey(name: 'eventTitle')
  final String title;
  @JsonKey(name: 'coverImageUrl')
  final String coverImageUrl;
  @JsonKey(name: 'eventCategory')
  final String category;
  @JsonKey(name: 'eventDescription')
  final String description;
  @JsonKey(name: 'eventLocation')
  final String? location;
  @JsonKey(name: 'endAt')
  final String endAt;
  @JsonKey(name: 'startAt')
  final String startAt;
  @JsonKey(name: 'isOnlineEvent')
  final bool isOnline;
  @JsonKey(name: 'galleryImagesUrls')
  final List<String> galleryImagesUrls;
  @JsonKey(name: 'ticketTiers')
  final List<TicketTier> ticketTiers;

  EventModel({
    required this.id,
    required this.title,
    required this.coverImageUrl,
    required this.category,
    required this.description,
    this.location,
    required this.endAt,
    required this.startAt,
    required this.isOnline,
    required this.galleryImagesUrls,
    required this.ticketTiers,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);

  Map<String, dynamic> toJson() => _$EventModelToJson(this);

}
