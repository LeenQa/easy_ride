import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/Assistants/requestAssistant.dart';
import 'package:easy_ride/Screens/Search/components/multicity_input.dart';
import 'package:easy_ride/components/keys.dart';
import 'package:easy_ride/components/main_drawer.dart';
import 'package:easy_ride/models/address.dart';
import 'package:easy_ride/models/place_prediction.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../tabs_screen.dart';

class PredictionTile extends StatefulWidget {
  PlacePrediction placePrediction;
  String pickORdrop;
  Function callback;
  PredictionTile(
      {Key key, this.placePrediction, this.pickORdrop, this.callback})
      : super(key: key);

  @override
  _PredictionTileState createState() => _PredictionTileState();
}

class _PredictionTileState extends State<PredictionTile> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (widget.pickORdrop == "pick") {
          getPlaceAddressDetails(
              widget.placePrediction.place_id, context, "pick");
        }
        if (widget.pickORdrop == "drop") {
          getPlaceAddressDetails(
              widget.placePrediction.place_id, context, "drop");
        }
        if (widget.pickORdrop == "offer_pick") {
          getPlaceAddressDetails(
              widget.placePrediction.place_id, context, "offer_pick");
        }
        if (widget.pickORdrop == "offer_drop") {
          getPlaceAddressDetails(
              widget.placePrediction.place_id, context, "offer_drop");
        } else {
          getPlaceAddressDetails(
              widget.placePrediction.place_id, context, "stop");
        }
      },
      child: Container(
        child: Column(
          children: [
            SizedBox(width: 10),
            Row(
              children: [
                Icon(Icons.add_location),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.placePrediction.main_text,
                          overflow: TextOverflow.ellipsis),
                      SizedBox(height: 3),
                      (widget.placePrediction.secondary_text == null
                          ? getTitle(title: widget.placePrediction.main_text)
                          : Text(widget.placePrediction.secondary_text,
                              overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getPlaceAddressDetails(String placeId, context, pd) async {
    String placeDetailsUrl =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";

    var response =
        await RequestAssistant.getRequest(Uri.parse(placeDetailsUrl));

    if (response == "Failed.") {
      return;
    }

    if (response["status"] == "OK") {
      Address address = Address();
      address.placeName = response["result"]["name"];
      address.placeId = placeId;
      address.latitude = response["result"]["geometry"]["location"]["lat"];
      address.longitude = response["result"]["geometry"]["location"]["lng"];

      if (pd == "pick") {
        Provider.of<Address>(context, listen: false)
            .updateSearchPickUpLocation(address);
        searched.startLocation = address.placeName;
        print("pick up location");
        print(address.placeName);
        widget.callback("pick");
      }
      if (pd == "drop") {
        Provider.of<Address>(context, listen: false)
            .updateSearchDropOffLocation(address);
        searched.arrivalLocation = address.placeName;
        print("drop off location");
        print(address.placeName);
        widget.callback("drop");
      }
      if (pd == "offer_pick") {
        Provider.of<Address>(context, listen: false)
            .updateOfferPickUpLocation(address);
        searched.startLocation = address.placeName;
        print("pick up location");
        print(address.placeName);
        widget.callback("pick");
      }
      if (pd == "offer_drop") {
        Provider.of<Address>(context, listen: false)
            .updateOfferDropOffLocation(address);
        searched.arrivalLocation = address.placeName;
        print("drop off location");
        print(address.placeName);
        widget.callback("drop");
        await getNearByPlaces(address.latitude, address.longitude);
      }
      if (pd == "stop") {
        Provider.of<Address>(context, listen: false)
            .updateStopOverLocation(address);
        //searched.arrivalLocation = address.placeName;
        print("stop over location");
        print(address.placeName);
        widget.callback("stop");
      }
    }
  }

  Future<void> getNearByPlaces(double latitude, double longitude) async {
    List results = [];
    List placesId = [];
    List nearbyPlaces = [];
    String nearbyUrl =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${latitude},${longitude}&radius=1000&key=${mapKey}";
    var nearbyResponse =
        await RequestAssistant.getRequest(Uri.parse(nearbyUrl));
    if (nearbyResponse == "Failed.") {
      return;
    }
    results = nearbyResponse["results"];
    for (int i = 0; i < results.length; i++) {
      placesId.add(results[i]['place_id']);
      nearbyPlaces.add(results[i]['name']);
    }
    print(nearbyPlaces);
    await FirebaseFirestore.instance
        .collection("nearbyPlaces")
        .doc(uid)
        .set({'nearbyPlaces': nearbyPlaces});
  }
}
