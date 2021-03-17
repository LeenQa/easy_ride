import './user.dart';
import './ride.dart';

enum Status { New, Accepted, Rejected, Finished }

class Request {
  Status status;
  User user;
  Ride ride;
}
