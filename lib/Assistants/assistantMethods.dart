import 'package:easy_ride/Assistants/requestAssistant.dart';
import 'package:easy_ride/components/configMaps.dart';
import 'package:easy_ride/models/address.dart';
import 'package:easy_ride/models/direction_details.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class AssistantMethods {
  static Future<String> searchCoordinateAddress(
      Position position, context) async {
    String placeAddress = "";
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";

    var response = await RequestAssistant.getRequest(Uri.parse(url));

    if (response != "Failed.") {
      placeAddress = response["results"][0]["formatted_address"];

      Address userPickedAddress = new Address(
          placeName: placeAddress,
          latitude: position.latitude,
          longitude: position.longitude);

      Provider.of<Address>(context, listen: false)
          .updateCurrentLocation(userPickedAddress);
    }

    return placeAddress;
  }

  static Future<DirectionsDetails> obtainPlaceDirectionDetails(
      LatLng pickUpPosition, LatLng dropOffPosition) async {
    String directionUrl =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${pickUpPosition.latitude},${pickUpPosition.longitude}&destination=${dropOffPosition.latitude},${dropOffPosition.longitude}&key=$mapKey";
    var response = await RequestAssistant.getRequest(Uri.parse(directionUrl));

    if (response == "Failed.") {
      return null;
    }

    DirectionsDetails directionDetails = new DirectionsDetails();
    directionDetails.encodingPoints =
        response["routes"][0]["overview_polyline"]["points"];
    directionDetails.distanceText =
        response["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue =
        response["routes"][0]["legs"][0]["distance"]["value"];
    directionDetails.durationText =
        response["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue =
        response["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetails;
  }
}
