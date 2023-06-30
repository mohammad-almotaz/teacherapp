class Validation {
  static String validationRequired(value, String massage) {
    if (value == null || value.isEmpty) return massage;
    return null;
  }

  static String validateEmail(value, String massage) {
    if (value == null || value.isEmpty) return massage;

    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    if (!emailRegExp.hasMatch(value)) {
      return 'Enter a correct email';
    }

    return null;
  }
}
