import 'dart:convert';

import 'package:easy_ride/Assistants/requestAssistant.dart';
import 'package:easy_ride/components/keys.dart';
import 'package:easy_ride/models/address.dart';
import 'package:easy_ride/models/direction_details.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
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

  static Future<Response> sendNotification(List<String> tokenIdList,
      String contents, String heading, String urlAvatar) async {
    return await post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "app_id":
            oneSignalKey, //kAppId is the App Id that one get from the OneSignal When the application is registered.

        "include_player_ids":
            tokenIdList, //tokenIdList Is the List of All the Token Id to to Whom notification must be sent.

        // android_accent_color reprsent the color of the heading text in the notifiction
        "android_accent_color": "FFFFA870",

        "small_icon": urlAvatar,
        "large_icon": urlAvatar,
        "headings": {"en": heading},
        "priority": 2,
        "contents": {"en": contents},
      }),
    );
  }
}
