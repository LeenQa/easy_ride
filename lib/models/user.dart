import 'package:flutter/foundation.dart';

enum Status {
  Student,
  Employee,
  Worker,
}

class User with ChangeNotifier {
  String _email;
  String _password;
  String _firstName;
  String _lastName;
  int _phone;

  User(
      [this._email,
      this._password,
      this._firstName,
      this._lastName,
      this._phone]);

  set email(value) => this._email = value;

  String get email => this._email;

  set firstName(value) => this._firstName = value;

  String get firstName => this._firstName;

  set lastName(value) => this._lastName = value;

  String get lastName => this._lastName;

  set password(value) => this._password = value;

  String get password => this._password;

  set phone(int value) => this._phone = value;

  int get phone => this._phone;
}
