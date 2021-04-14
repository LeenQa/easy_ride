import 'dart:async';
import 'package:easy_ride/Assistants/assistantMethods.dart';
import 'package:easy_ride/Screens/Search/components/multicity_input.dart';
import 'package:easy_ride/components/main_drawer.dart';
import 'package:easy_ride/constants.dart';
import 'package:easy_ride/models/address.dart';
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

  void locatePostition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        new CameraPosition(target: latLatPosition, zoom: 14);
    latLngBounds == null
        ? newGoogleMapController
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition))
        : newGoogleMapController
            .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));
    address = await AssistantMethods.searchCoordinateAddress(position, context);

    print(address.length);
    print("this is address ${address}");
  }

  LatLng northEast = LatLng(33.304222, 34.790746);
  LatLng southWest = LatLng(29.596533, 35.222665);

  @override
  Widget build(BuildContext context) {
    /* var resultLocation = Provider.of<Address>(context).pickUpLocation != null
        ? Provider.of<Address>(context).pickUpLocation.placeName
        : "waiiting"; */
    return new Scaffold(
      appBar: AppBar(
        title: Text(
          "Map",
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
                  bottom: MediaQuery.of(context).size.height * 0.14, top: 15),
              mapType: MapType.normal,
              initialCameraPosition: _kPalestine,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              polylines: polylineSet,
              markers: markersSet,
              circles: circlesSet,
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
                height: MediaQuery.of(context).size.height * 0.14,
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
                      SizedBox(height: 6),
                      getTitle(title: "Current Location:"),
                      SizedBox(height: 20),
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
