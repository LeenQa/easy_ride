import 'package:flutter/foundation.dart';

import './ride.dart';
import './user.dart';

class Driver with ChangeNotifier {
  User _user;
  String _carModel;
  List<String> _setOfRules;
  List<Ride> _rides;
  List<String> _pictures;

  Driver([this._user, this._carModel, this._setOfRules, this._rides]);

  set user(value) => this._user = value;
  User get user => this._user;
  set carModel(value) => this._carModel = value;
  String get carModel => this._carModel;
  set setOfRules(value) => this._setOfRules = value;
  List<String> get setOfRules => this._setOfRules;
  set rides(value) => this._rides = value;
  List<Ride> get rides => this._rides;
}
