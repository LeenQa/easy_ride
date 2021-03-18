import 'package:flutter/foundation.dart';

import 'driver.dart';

class Ride with ChangeNotifier {
  DateTime _startTime;
  DateTime _arrivalTime;
  String _startLocation;
  String _arrivalLocation;
  DateTime _date;
  int _numOfPassengers;
  double _price;
  List<String> _stopOvers;
  Driver _driver;

  Ride(
      [this._startTime,
      this._arrivalTime,
      this._startLocation,
      this._arrivalLocation,
      this._date,
      this._numOfPassengers,
      this._price,
      this._stopOvers,
      this._driver]);

  set startTime(value) => this._startTime = value;
  DateTime get startTime => this._startTime;
  set arrivalTime(value) => this._arrivalTime = value;
  DateTime get arrivalTime => this._arrivalTime;
  set startLocation(value) => this._startLocation = value;
  String get startLocation => this._startLocation;
  set arrivalLocation(value) => this._arrivalLocation = value;
  String get arrivalLocation => this._arrivalLocation;
  set date(value) => this._date = value;
  DateTime get date => this._date;
  set numOfPassengers(value) => this._numOfPassengers = value;
  int get numOfPassengers => this._numOfPassengers;
  set price(value) => this._price = value;
  double get price => this._price;
  set stopOvers(value) => this._stopOvers = value;
  List<String> get stopOvers => this._stopOvers;
  set driver(value) => this._driver = value;
  Driver get driver => this._driver;

  int getDuration() {
    return this._arrivalTime.difference(this._startTime).inHours;
  }
}
