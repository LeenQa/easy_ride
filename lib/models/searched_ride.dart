import 'package:flutter/material.dart';

class SearchedRide {
  String pickUpLocation;
  String dropOffLocation;
  DateTime date;
  int numOfPassengers;

  SearchedRide(
      {this.pickUpLocation,
      this.dropOffLocation,
      this.date,
      this.numOfPassengers});
}
/* 

                          SearchedRide searchRide = SearchedRide(
                              pickUpLocation: searched.startLocation,
                              dropOffLocation: searched.arrivalLocation,
                              date: _selectedDate,
                              numOfPassengers: searched.numOfPassengers); */
