import 'package:flutter/foundation.dart';

import './ride.dart';
import './user.dart';

class Driver with ChangeNotifier {
  User user;
  String carModel;
  List<String> setOfRules;
  List<Ride> rides;
}
