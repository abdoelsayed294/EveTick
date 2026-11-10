class AppRegex {
  static bool isEmailValid(String email) {
    return RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(email);
  }

  static bool isPasswordValid(String password) {
    return RegExp(
      r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$"
    ).hasMatch(password);
  }
  static bool isPhoneNumberValid(String phone) {
    return RegExp(r'^\+?[0-9]{10,15}$').hasMatch(phone);
  }

  static bool isCardNumberValid(String cardNumber) {
    final digitsOnly = cardNumber.replaceAll(' ', '');
    return RegExp(r'^[0-9]{16}$').hasMatch(digitsOnly);
  }

  static bool isExpiryDateValid(String expiryDate) {
    return RegExp(r'^(0[1-9]|1[0-2])\/[0-9]{2}$').hasMatch(expiryDate);
  }

  static bool isCvvValid(String cvv) {
    return RegExp(r'^[0-9]{3,4}$').hasMatch(cvv);
  }
}