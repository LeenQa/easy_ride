import 'package:flutter/material.dart';

class SearchedRide with ChangeNotifier {
  String pickUpLocation;
  String dropOffLocation;
  String date;
  int numOfPassengers;
  String currentUser;
  String ride;
  String status;
  String request;
  bool isReviewed;

  //SearchedRide searchedRide;
  SearchedRide(
      {this.pickUpLocation,
      this.dropOffLocation,
      this.date,
      this.numOfPassengers,
      this.currentUser,
      this.ride,
      this.status,
      this.request,
      this.isReviewed});
}
