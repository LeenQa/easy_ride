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

  Address searchRidePickUpLocation;
  Address searchRideDropOffLocation;
  Address currentLocation;
  Address userLocation;
  Address offerRidePickUpLocation;
  Address offerRideDropOffLocation;
  Address stopOverLocation;

  void updateSearchPickUpLocation(Address pickUpAddress) {
    searchRidePickUpLocation = pickUpAddress;
    notifyListeners();
  }

  void updateSearchDropOffLocation(Address dropOffAddress) {
    searchRideDropOffLocation = dropOffAddress;
    notifyListeners();
  }

  void updateCurrentLocation(Address currentAddress) {
    currentLocation = currentAddress;
    notifyListeners();
  }

  void updateUserLocation(Address userAddress) {
    userLocation = userAddress;
    notifyListeners();
  }

  void updateOfferPickUpLocation(Address pickUpAddress) {
    offerRidePickUpLocation = pickUpAddress;
    notifyListeners();
  }

  void updateOfferDropOffLocation(Address dropOffAddress) {
    offerRideDropOffLocation = dropOffAddress;
    notifyListeners();
  }

  void updateStopOverLocation(Address stopoOverAddress) {
    stopOverLocation = stopoOverAddress;
    notifyListeners();
  }
}
