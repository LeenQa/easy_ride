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
  String _phone;
  String _location;
  String _urlAvatar;
  bool _isDriver;

  User(
      [this._email,
      this._password,
      this._firstName,
      this._lastName,
      this._phone,
      this._location,
      this._urlAvatar,
      this._isDriver]);

  set email(value) => this._email = value;

  String get email => this._email;

  set firstName(value) => this._firstName = value;

  String get firstName => this._firstName;

  set lastName(value) => this._lastName = value;

  String get lastName => this._lastName;

  set password(value) => this._password = value;

  String get password => this._password;

  set phone(String value) => this._phone = value;

  String get phone => this._phone;

  set location(value) => this._location = value;

  String get location => this._location;

  set urlAvatar(value) => this._urlAvatar = value;

  String get urlAvatar => this._urlAvatar;

  set isDriver(value) => this._isDriver = value;

  bool get isDriver => this._isDriver;
}
