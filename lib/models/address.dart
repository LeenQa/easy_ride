import 'package:flutter/cupertino.dart';

class Address extends ChangeNotifier {
  String placeFormattedAddress;
  String placeName;
  String placeId;
  double latitude;
  double longitude;

  Address({
    this.placeFormattedAddress,
    this.placeName,
    this.placeId,
    this.latitude,
    this.longitude,
  });

  Address pickUpLocation;
  Address dropOffLocation;
  Address currentLocation;

  void updatePickUpLocation(Address pickUpAddress) {
    pickUpLocation = pickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocation(Address dropOffAddress) {
    dropOffLocation = dropOffAddress;
    notifyListeners();
  }

  void updateCurrentLocation(Address currentAddress) {
    currentLocation = currentAddress;
    notifyListeners();
  }
}
