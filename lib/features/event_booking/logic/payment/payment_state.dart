import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_state.freezed.dart';

@freezed
class PaymentState with _$PaymentState {
  const factory PaymentState.initial() = _Initial;

  const factory PaymentState.loading() = Loading;

  const factory PaymentState.awaitingPayment({
    required String orderId,
    required String paymentUrl,
  }) = AwaitingPayment;

  const factory PaymentState.paymentPending({
    required String orderId,
    required String paymentUrl,
  }) = PaymentPending;

  const factory PaymentState.success({required String orderId}) = Success;

  const factory PaymentState.error({required String error}) = Error;
}
