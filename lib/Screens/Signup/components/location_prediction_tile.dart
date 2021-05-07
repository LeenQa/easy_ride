import 'package:easy_ride/Assistants/requestAssistant.dart';
import 'package:easy_ride/components/configMaps.dart';
import 'package:easy_ride/models/address.dart';
import 'package:easy_ride/models/place_prediction.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PredictionTile extends StatefulWidget {
  PlacePrediction placePrediction;
  Function callback;
  PredictionTile({Key key, this.placePrediction, this.callback})
      : super(key: key);

  @override
  _PredictionTileState createState() => _PredictionTileState();
}

class _PredictionTileState extends State<PredictionTile> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return TextButton(
      onPressed: () {
        getPlaceAddressDetails(widget.placePrediction.place_id, context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: size.width * 0.8,
        child: Column(
          children: [
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
                      (widget.placePrediction.secondary_text == null
                          ? Text(widget.placePrediction.main_text)
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

  Future<void> getPlaceAddressDetails(String placeId, context) async {
    String placeDetailsUrl =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";
    print(placeDetailsUrl);

    var response =
        await RequestAssistant.getRequest(Uri.parse(placeDetailsUrl));

    if (response == "Failed.") {
      return;
    }

    if (response["status"] == "OK") {
      Address address = Address();
      address.placeName =
          response["result"]["address_components"][0]["short_name"];
      address.placeId = placeId;
      address.latitude = response["result"]["geometry"]["location"]["lat"];
      address.longitude = response["result"]["geometry"]["location"]["lng"];

      Provider.of<Address>(context, listen: false).updateUserLocation(address);
      //searched.startLocation = address.placeName;
      print("user location");
      print(address.placeName);
      widget.callback();
    }
  }
}
