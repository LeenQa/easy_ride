class FieldValidation {
  static String validatePassword(String password) {
    RegExp passRegex = RegExp(
        r"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[^a-zA-Z0-9])(?!.*\s).{8,}$");
    if (password.isEmpty || !passRegex.hasMatch(password)) {
      return "Password should be strong";
    } else
      return null;
  }

  static String validateUsername(String username) {
    RegExp passRegex = RegExp(r"^[a-zA-Z][a-zA-Z\._]{4,14}[a-zA-Z]$");
    if (username.isEmpty || !passRegex.hasMatch(username)) {
      return "Username can't contain symbols";
    } else
      return null;
  }
}
