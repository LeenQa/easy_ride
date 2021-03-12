import 'package:easy_ride/localization/language_constants.dart';
import 'package:flutter/cupertino.dart';

class FieldValidation {
  static String validatePassword(String password, BuildContext context) {
    RegExp passRegex = RegExp(
        r"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[^a-zA-Z0-9])(?!.*\s).{8,}$");
    if (password.isEmpty || !passRegex.hasMatch(password)) {
      return "Password should be strong";
    } else
      return null;
  }

  static String validateUsername(String username, BuildContext context) {
    RegExp passRegex = RegExp(r"^[a-zA-Z][a-zA-Z\._]{3,}[a-zA-Z1-9]$");
    if (username.isEmpty) {
      return getTranslated(context, 'fillemptyfields');
    } else if (!passRegex.hasMatch(username)) {
      return getTranslated(context, 'usernameerror');
    } else
      return null;
  }
}
