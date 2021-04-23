import 'dart:async';
import 'package:easy_ride/Assistants/assistantMethods.dart';
import 'package:easy_ride/Screens/Offer_Ride/offer_ride_screen.dart' as Offer;
import 'package:easy_ride/Screens/Search/components/multicity_input.dart'
    as Search;
import 'package:easy_ride/components/main_drawer.dart';
import 'package:easy_ride/constants.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:easy_ride/models/address.dart';
import 'package:easy_ride/models/direction_details.dart';
import 'package:easy_ride/text_style.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  static const String routeName = "/map";
  @override
  _MapScreenState createState() => _MapScreenState();
}

String address;

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    super.initState();
  }

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController newGoogleMapController;

  static final CameraPosition _kPalestine = CameraPosition(
    target: LatLng(31.71081, 35.198666),
    zoom: 10.4746,
  );

  Position currentPosition;
  var geolocator = Geolocator();

  @override
  Widget build(BuildContext context) {
    var arg = ModalRoute.of(context).settings.arguments;
    print(arg);
    bool search = arg == "search_for_a_ride";
    var price;
    search
        ? Search.directionsDetails != null
            ? price =
                (Search.directionsDetails.distanceValue / 1000 * 0.4).truncate()
            : price = null
        : Offer.directionsDetails != null
            ? price =
                (Offer.directionsDetails.distanceValue / 1000 * 0.4).truncate()
            : price = null;

    if (price == 0) {
      price = 1;
    }

    var distance;
    search
        ? Search.directionsDetails != null
            ? distance =
                (Search.directionsDetails.distanceValue / 1000).truncate()
            : distance = null
        : Offer.directionsDetails != null
            ? distance =
                (Offer.directionsDetails.distanceValue / 1000).truncate()
            : distance = null;

    var pad;
    search
        ? Search.directionsDetails != null
            ? pad = 0.20
            : pad = 0.15
        : Offer.directionsDetails != null
            ? pad = 0.20
            : pad = 0.15;

    /* var resultLocation = Provider.of<Address>(context).pickUpLocation != null
        ? Provider.of<Address>(context).pickUpLocation.placeName
        : "waiiting"; */
    void locatePostition() async {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      currentPosition = position;

      LatLng latLatPosition = LatLng(position.latitude, position.longitude);

      CameraPosition cameraPosition =
          new CameraPosition(target: latLatPosition, zoom: 14);
      search
          ? Search.latLngBounds == null
              ? newGoogleMapController
                  .animateCamera(CameraUpdate.newCameraPosition(cameraPosition))
              : newGoogleMapController.animateCamera(
                  CameraUpdate.newLatLngBounds(Search.latLngBounds, 70))
          : Offer.latLngBounds == null
              ? newGoogleMapController
                  .animateCamera(CameraUpdate.newCameraPosition(cameraPosition))
              : newGoogleMapController.animateCamera(
                  CameraUpdate.newLatLngBounds(Offer.latLngBounds, 70));

      address =
          await AssistantMethods.searchCoordinateAddress(position, context);

      print(address.length);
      print("this is address ${address}");
    }

    LatLng northEast = LatLng(33.304222, 34.790746);
    LatLng southWest = LatLng(29.596533, 35.222665);
    return new Scaffold(
      appBar: AppBar(
        title: Text(
          getTranslated(context, "map"),
          style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      body: WillPopScope(
        onWillPop: () async {
          //Navigator.pop(context, resultLocation);
          Navigator.pop(context);
          return false;
        },
        child: Stack(
          children: [
            GoogleMap(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * pad, top: 15),
              mapType: MapType.normal,
              initialCameraPosition: _kPalestine,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              polylines: search ? Search.polylineSet : Offer.polylineSet,
              markers: search ? Search.markersSet : Offer.markersSet,
              circles: search ? Search.circlesSet : Offer.circlesSet,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                newGoogleMapController = controller;

                locatePostition();
              },
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * pad,
                //height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 16,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      distance == null
                          ? Container()
                          : Text(
                              "Distance between the two places: $distance km",
                              style: blueSubHeadingTextStyle),
                      SizedBox(height: 4),
                      price == null
                          ? Container()
                          : Text("Estimated cost: $price NIS",
                              style: blueSubHeadingTextStyle),
                      SizedBox(height: 10),
                      getTitle(
                          title: getTranslated(context, "currentlocation")),
                      SizedBox(height: 15),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.location_on_rounded,
                                color: kPrimaryColor),
                            SizedBox(width: 10),
                            Provider.of<Address>(context).currentLocation ==
                                    null
                                ? Center(child: CircularProgressIndicator())
                                : getTitle(
                                    title: Provider.of<Address>(context)
                                        .currentLocation
                                        .placeName)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
