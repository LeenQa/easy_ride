import 'package:easy_ride/models/searched_ride.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'driver.dart';

class Ride with ChangeNotifier {
  String _startTime;
  // DateTime _arrivalTime;
  String _startLocation;
  String _arrivalLocation;
  String _date;
  int _numOfPassengers;
  String _price;
  List _stopOvers;
  String _driver;
  String _description;
  List<String> _requests;
  String _id;
  String _status;

  /* List<Ride> exactRides = [];
  List<Ride> otherRides = []; */

  Ride(
      [this._startTime,
      // this._arrivalTime,
      this._startLocation,
      this._arrivalLocation,
      this._date,
      this._numOfPassengers,
      this._price,
      this._stopOvers,
      this._driver,
      this._description,
      this._requests,
      this._id,
      this._status]);

  set startTime(value) => this._startTime = value;
  String get startTime => this._startTime;
  // set arrivalTime(value) => this._arrivalTime = value;
  // DateTime get arrivalTime => this._arrivalTime;
  set startLocation(value) => this._startLocation = value;
  String get startLocation => this._startLocation;
  set arrivalLocation(value) => this._arrivalLocation = value;
  String get arrivalLocation => this._arrivalLocation;
  set date(value) => this._date = value;
  String get date => this._date;
  set numOfPassengers(value) => this._numOfPassengers = value;
  int get numOfPassengers => this._numOfPassengers;
  set price(value) => this._price = value;
  String get price => this._price;
  set stopOvers(value) => this._stopOvers = value;
  List get stopOvers => this._stopOvers;
  set driver(value) => this._driver = value;
  String get driver => this._driver;
  set description(value) => this._description = value;
  String get description => this._description;
  set requests(value) => this._requests = value;
  List<String> get requests => this._requests;
  set id(value) => this._id = value;
  String get id => this._id;
  set status(value) => this._status = value;
  String get status => this._status;
  // int getDuration() {
  //   return this._arrivalTime.difference(this._startTime).inHours;
  // }
}
