
class PaymobConfig {
  const PaymobConfig._();

  static const String publicKey = 'egy_pk_test_JNKuPnqBD4RJ1zoM1Bi2kub9baPgpRAD';

  
  static const String createPaymentUrl =
      'https://createpayment-l5eh6czplq-uc.a.run.app';

 
  static String checkoutUrl(String clientSecret) =>
      'https://accept.paymob.com/unifiedcheckout/'
      '?publicKey=$publicKey&clientSecret=$clientSecret';
}
