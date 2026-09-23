import 'package:evetick/features/event_booking/data/models/event_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'select_tickets_state.freezed.dart';

@freezed
abstract class SelectTicketsState with _$SelectTicketsState {
  const factory SelectTicketsState.initial() = Initial;
  const factory SelectTicketsState.loading() = Loading;
  const factory SelectTicketsState.success(List<TicketTier> ticketTiers) = Success;
  const factory SelectTicketsState.error({required String error}) = Error;
}
