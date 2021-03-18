import 'package:flutter/foundation.dart';

import './user.dart';
import './ride.dart';

enum Status { New, Accepted, Rejected, Finished }

class Request with ChangeNotifier {
  Status status;
  User user;
  Ride ride;
}
