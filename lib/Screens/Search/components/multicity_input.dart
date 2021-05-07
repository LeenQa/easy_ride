import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/Assistants/assistantMethods.dart';
import 'package:easy_ride/Assistants/requestAssistant.dart';
import 'package:easy_ride/Screens/Map/map_screen.dart';
import 'package:easy_ride/Screens/Rides_List/rides_list.dart';
import 'package:easy_ride/Screens/Search/components/prediction_tile.dart';
import 'package:easy_ride/components/configMaps.dart';
import 'package:easy_ride/components/info_container.dart';
import 'package:easy_ride/components/main_drawer.dart';
import 'package:easy_ride/constants.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:easy_ride/models/address.dart';
import 'package:easy_ride/models/direction_details.dart';
import 'package:easy_ride/models/driver.dart';
import 'package:easy_ride/models/place_prediction.dart';
import 'package:easy_ride/models/places.dart';
import 'package:easy_ride/models/ride.dart';
import 'package:easy_ride/models/searched_ride.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:provider/provider.dart';

class MulticityInput extends StatefulWidget {
  @override
  _MulticityInputState createState() => _MulticityInputState();
}

List<PlacePrediction> pickUpPlacePredictionList = [];
List<PlacePrediction> dropOffPlacePredictionList = [];
TextEditingController pickUpController = TextEditingController();
TextEditingController dropOffController = TextEditingController();
List<LatLng> pLineCoordinates = [];
Set<Polyline> polylineSet = {};
LatLngBounds latLngBounds;
Set<Marker> markersSet = {};
Set<Circle> circlesSet = {};
Ride searched = Ride();
List<Ride> results = [];
bool searchFound = false;
var result;
var _res;
DirectionsDetails directionsDetails;
List<Ride> exactRides = [];
List<Ride> otherRides = [];
SearchedRide searchedRide;

List<Ride> Search(String from, String to, DateTime time, List<Ride> rides) {
  List<Ride> matches = [];
  for (int i = 0; i < rides.length; i++) {
    print(rides[0].startLocation);
    if (rides[i].startLocation.toLowerCase().contains(from.toLowerCase()) &&
        rides[i].arrivalLocation.toLowerCase().contains(to
            .toLowerCase())) /* &&
        time.year == rides[i].date.year &&
        time.month == rides[i].date.month &&
        time.day == rides[i].date.day) */
    {
      print("passed");
      matches.add(rides[i]);
    }
  }
  if (matches.isEmpty)
    return [];
  else
    return matches;
}

class _MulticityInputState extends State<MulticityInput> {
  List<Place> places;

  DateTime _selectedDate;
  Ride ride1 = new Ride(
      "TimeOfDay.now()",
      //DateFormat('h:mm:ssa', 'en_US').parseLoose('4:00:00PM'),
      "Bethlehem",
      "Ramallah",
      "DateTime.now()",
      2,
      "20.00",
      ["Jericho", "Ebediye"],
      "driver"
      /* new Driver(
      new User.User("email", "password", "Leen", "Qazaha", 059473232),
      "Alfa Romeo giulia",
      ["No smoking", "No pets"],
    ), */
      );
  Ride ride2 = new Ride(
      "TimeOfDay.now()",
      //DateFormat('h:mm:ssa', 'en_US').parseLoose('4:00:00PM'),
      "Bethlehem",
      "Ramallah",
      "DateTime.now()",
      2,
      "20.00",
      ["Jericho", "Ebediye"],
      "driver"
      /* new Driver(
      new User.User("email", "password", "Leen", "Qazaha", 059473232),
      "Alfa Romeo giulia",
      ["No smoking", "No pets"],
    ), */
      );

  @override
  void initState() {
    super.initState();
    getUser();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  String uid;
  User user;
  getUser() {
    final User user = auth.currentUser;
    uid = user.uid;
    this.user = user;
  }

  callback(String pd) {
    setState(() {
      pickUpPlacePredictionList = [];
      dropOffPlacePredictionList = [];
      if (pd == "pick") {
        pickUpController.text = Provider.of<Address>(context, listen: false)
            .searchRidePickUpLocation
            .placeName;
      }
      if (pd == "drop") {
        dropOffController.text = Provider.of<Address>(context, listen: false)
            .searchRideDropOffLocation
            .placeName;
      }
    });
  }

  Widget row(Place place) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          place.place,
          style: TextStyle(fontSize: 16.0),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var localizations = MaterialLocalizations.of(context).toString();
    var padding;

    setState(() {
      if (localizations.contains("En")) {
        padding = EdgeInsets.fromLTRB(0.0, 0.0, 64.0, 8.0);
      } else {
        padding = EdgeInsets.fromLTRB(64.0, 0.0, 0.0, 8.0);
      }
    });

    List<Ride> rides = [ride1, ride2];
    void _presentDatePicker() {
      showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2022))
          .then((pickedDate) {
        if (pickedDate != null) {
          setState(() {
            _selectedDate = pickedDate;
          });
        } else
          return;
      });
    }

    return Column(
      children: [
        results.isNotEmpty
            ? RidesList(
                transactions: results,
                title: getTranslated(context, "rideresults"))
            : Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Form(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        //Text(_res == null ? "not chosen yet" : _res),
                        Padding(
                          padding: padding,
                          child: TextFormField(
                            controller: pickUpController,
                            decoration: InputDecoration(
                              icon: Icon(Icons.local_taxi_rounded,
                                  color: kPrimaryColor),
                              labelText: getTranslated(context, 'from'),
                            ),
                            onChanged: (value) {
                              findPickUp(value);
                            },
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                        (pickUpPlacePredictionList.length > 0)
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                child: ListView.separated(
                                    itemBuilder: (context, index) {
                                      //return Text("data");
                                      return PredictionTile(
                                        placePrediction:
                                            pickUpPlacePredictionList[index],
                                        pickORdrop: "pick",
                                        callback: callback,
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            Divider(),
                                    itemCount: pickUpPlacePredictionList.length,
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics()),
                              )
                            : Container(),
                        Padding(
                          padding: padding,
                          child: TextFormField(
                            controller: dropOffController,
                            decoration: InputDecoration(
                              icon: Icon(Icons.local_taxi_rounded,
                                  color: kPrimaryColor),
                              labelText: getTranslated(context, 'to'),
                            ),
                            onChanged: (value) {
                              findDropOff(value);
                            },
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                        (dropOffPlacePredictionList.length > 0)
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                child: ListView.separated(
                                    itemBuilder: (context, index) {
                                      //return Text("data");
                                      return PredictionTile(
                                          placePrediction:
                                              dropOffPlacePredictionList[index],
                                          pickORdrop: "drop",
                                          callback: callback);
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            Divider(),
                                    itemCount:
                                        dropOffPlacePredictionList.length,
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics()),
                              )
                            : Container(),
                        TextButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  return kPrimaryColor;
                                },
                              ),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              )),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20)),
                              textStyle: MaterialStateProperty.all(
                                  TextStyle(fontSize: 30))),
                          onPressed: () async {
                            (Provider.of<Address>(context, listen: false)
                                            .searchRidePickUpLocation ==
                                        null) ||
                                    (Provider.of<Address>(context,
                                                listen: false)
                                            .searchRideDropOffLocation ==
                                        null)
                                ? {}
                                : await getPlaceDirection();
                            await Navigator.of(context)
                                .pushNamed(MapScreen.routeName,
                                    arguments: "search_for_a_ride")
                                .then((value) {
                              setState(() {
                                _res = value;
                              });
                            });
                          },
                          child: getTitle(
                              title: getTranslated(context, "directions"),
                              color: Colors.white,
                              fontSize: 14),
                        ),

                        Padding(
                          padding: padding,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              icon: Icon(Icons.person, color: kPrimaryColor),
                              labelText: getTranslated(context, 'numofpass'),
                            ),
                            onChanged: (value) {
                              try {
                                searched.numOfPassengers = int.parse(value);
                              } catch (exp) {}
                            },
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          child: Container(
                            height: 70,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.date_range,
                                        color: kPrimaryColor),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    TextButton(
                                      style: ButtonStyle(
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.symmetric(
                                                  vertical: 10, horizontal: 0)),
                                          textStyle: MaterialStateProperty.all(
                                              TextStyle(fontSize: 30))),
                                      onPressed: _presentDatePicker,
                                      child: getTitle(
                                          title: getTranslated(
                                              context, "choosedate"),
                                          color: Colors.grey[700],
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Text(_selectedDate == null
                                      ? ''
                                      : DateFormat(
                                              '\'Picked date: \' EEE, MMM d')
                                          .format(_selectedDate)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: TextButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    return kPrimaryColor;
                                  },
                                ),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                )),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20)),
                                textStyle: MaterialStateProperty.all(
                                    TextStyle(fontSize: 30))),
                            onPressed: () async {
                              exactRides.clear();
                              otherRides.clear();
                              await FirebaseFirestore.instance
                                  .collection("users")
                                  .get()
                                  .then((querySnapshot) {
                                querySnapshot.docs.forEach((result) async {
                                  await FirebaseFirestore.instance
                                      .collection("rides")
                                      .doc(result.id)
                                      .collection("userrides")
                                      .where("arrivalLocation",
                                          isEqualTo: searched.arrivalLocation)
                                      .where("date",
                                          isEqualTo: DateFormat('EEE, MMM d')
                                              .format(_selectedDate))
                                      .get()
                                      .then((querySnapshot) {
                                    querySnapshot.docs.forEach((result) {
                                      print("${querySnapshot.size} size");
                                      print(result.data()['startLocation']);
                                      String startTime =
                                          result.data()['startTime'];
                                      String startLocation =
                                          result.data()['startLocation'];
                                      String arrivalLocation =
                                          result.data()['arrivalLocation'];
                                      String date = result.data()['date'];
                                      int numOfPassengers =
                                          result.data()['numOfPassengers'];
                                      String price = result.data()['price'];
                                      List stopovers =
                                          result.data()['stopovers'];
                                      String driver = result.data()['driver'];
                                      String description =
                                          result.data()['description'];
                                      String id = result.id;
                                      Ride ride = new Ride(
                                          startTime,
                                          startLocation,
                                          arrivalLocation,
                                          date,
                                          numOfPassengers,
                                          price,
                                          stopovers,
                                          driver,
                                          description,
                                          [],
                                          id);
                                      searchedRide = SearchedRide(
                                          pickUpLocation:
                                              searched.startLocation,
                                          dropOffLocation:
                                              searched.arrivalLocation,
                                          date: DateFormat('EEE, MMM d')
                                              .format(_selectedDate),
                                          numOfPassengers:
                                              searched.numOfPassengers,
                                          currentUser: uid);
                                      if (ride.numOfPassengers >=
                                          searched.numOfPassengers) {
                                        if (ride.startLocation ==
                                                searched.startLocation ||
                                            ride.stopOvers.contains(
                                                searched.startLocation)) {
                                          exactRides.add(ride);
                                          print(searchedRide.date);
                                          print(
                                              "exactrides: ${exactRides.length}");
                                        } else {
                                          otherRides.add(ride);
                                          print(
                                              "otherrides: ${otherRides.length}");
                                        }
                                      }
                                    });
                                  });
                                });
                              });

                              Future.delayed(const Duration(seconds: 1))
                                  .then((_) {
                                Navigator.of(context)
                                    .pushNamed(RidesList.routeName);
                              });
                            },
                            child: getTitle(
                                title: getTranslated(context, "search"),
                                color: Colors.white,
                                fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        InfoContainer(
          colors: [
            kSecondaryColor,
            redColor,
          ],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.note,
                    color: Colors.white,
                  ),
                  getTitle(title: "Tip", color: Colors.white, fontSize: 16),
                ],
              ),
              getTitle(
                  title:
                      "If there are no results for your search you can press (notify me) to get a nontification.",
                  color: Colors.white,
                  fontSize: 14),
            ],
          ),
        ),
      ],
    );
  }

  void findPickUp(String placeName) async {
    if (placeName.length > 1) {
      String autoCompleteUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:PS";

      var response =
          await RequestAssistant.getRequest(Uri.parse(autoCompleteUrl));

      if (response == "Failed.") {
        return;
      }

      if (response["status"] == "OK") {
        var predictions = response["predictions"];
        var placesList = (predictions as List)
            .map((e) => PlacePrediction.fromJson(e))
            .toList();
        setState(() {
          pickUpPlacePredictionList = placesList;
        });
      }
      print(response);
    }
  }

  void findDropOff(String placeName) async {
    if (placeName.length > 1) {
      String autoCompleteUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:PS";

      var response =
          await RequestAssistant.getRequest(Uri.parse(autoCompleteUrl));

      if (response == "Failed.") {
        return;
      }

      if (response["status"] == "OK") {
        var predictions = response["predictions"];
        var placesList = (predictions as List)
            .map((e) => PlacePrediction.fromJson(e))
            .toList();
        setState(() {
          dropOffPlacePredictionList = placesList;
        });
      }
      print(response);
    }
  }

  Future<void> getPlaceDirection() async {
    var initialPos =
        Provider.of<Address>(context, listen: false).searchRidePickUpLocation;
    var finalPos =
        Provider.of<Address>(context, listen: false).searchRideDropOffLocation;

    var pickUpLatLng = LatLng(initialPos.latitude, initialPos.longitude);
    var dropOffLatLnt = LatLng(finalPos.latitude, finalPos.longitude);

    var details = await AssistantMethods.obtainPlaceDirectionDetails(
        pickUpLatLng, dropOffLatLnt);

    setState(() {
      directionsDetails = details;
    });

    print("encoded points");
    print(details.encodingPoints);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResult =
        polylinePoints.decodePolyline(details.encodingPoints);
    pLineCoordinates.clear();
    if (decodedPolyLinePointsResult.isNotEmpty) {
      decodedPolyLinePointsResult.forEach((PointLatLng pointLatLng) {
        pLineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polylineSet.clear();
    setState(() {
      Polyline polyline = Polyline(
        color: Colors.red,
        polylineId: PolylineId("PolylineID"),
        jointType: JointType.round,
        points: pLineCoordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      polylineSet.add(polyline);
    });

    if (pickUpLatLng.latitude > dropOffLatLnt.latitude &&
        pickUpLatLng.longitude > dropOffLatLnt.longitude) {
      latLngBounds =
          LatLngBounds(southwest: dropOffLatLnt, northeast: pickUpLatLng);
    } else if (pickUpLatLng.longitude > dropOffLatLnt.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(pickUpLatLng.latitude, dropOffLatLnt.longitude),
          northeast: LatLng(dropOffLatLnt.latitude, pickUpLatLng.longitude));
    } else if (pickUpLatLng.latitude > dropOffLatLnt.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(dropOffLatLnt.latitude, pickUpLatLng.longitude),
          northeast: LatLng(pickUpLatLng.latitude, dropOffLatLnt.longitude));
    } else {
      latLngBounds =
          LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLnt);
    }

    Marker pickUpMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(title: initialPos.placeName),
      position: pickUpLatLng,
      markerId: MarkerId("pickUpId"),
    );
    Marker dropOffMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      infoWindow: InfoWindow(title: finalPos.placeName),
      position: dropOffLatLnt,
      markerId: MarkerId("dropOffId"),
    );

    setState(() {
      markersSet.clear();
      markersSet.add(pickUpMarker);
      markersSet.add(dropOffMarker);
    });

    Circle pickUpCircle = Circle(
      fillColor: Colors.redAccent,
      center: pickUpLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.redAccent,
      circleId: CircleId("pickUpId"),
    );

    Circle dropOffCircle = Circle(
      fillColor: Colors.blueAccent,
      center: dropOffLatLnt,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.blueAccent,
      circleId: CircleId("dropOffId"),
    );

    setState(() {
      circlesSet.add(pickUpCircle);
      circlesSet.add(dropOffCircle);
    });
  }
}
