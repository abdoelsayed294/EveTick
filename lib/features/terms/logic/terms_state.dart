import 'package:evetick/features/terms/data/models/terms_acceptance_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'terms_state.freezed.dart';

@freezed
class TermsState with _$TermsState {
  const factory TermsState.initial() = _Initial;
  const factory TermsState.loading() = TermsLoading;
  const factory TermsState.loaded(TermsAcceptanceModel acceptance) =
      TermsLoaded;
  const factory TermsState.saving() = TermsSaving;
  const factory TermsState.saved() = TermsSaved;
  const factory TermsState.error({required String error}) = TermsError;
}
