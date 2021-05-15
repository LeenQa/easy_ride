import 'dart:async' show Future;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/Assistants/assistantMethods.dart';
import 'package:easy_ride/Assistants/requestAssistant.dart';
import 'package:easy_ride/Screens/Map/map_screen.dart';
import 'package:easy_ride/Screens/Search/components/prediction_tile.dart';
import 'package:easy_ride/components/keys.dart';
import 'package:easy_ride/models/address.dart';
import 'package:easy_ride/models/direction_details.dart';
import 'package:easy_ride/models/place_prediction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:easy_ride/components/main_drawer.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:easy_ride/models/places.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../text_style.dart';

class OfferRideScreen extends StatefulWidget {
  static const routeName = '/offer_ride';

  @override
  _OfferRideScreenState createState() => _OfferRideScreenState();
}

List<PlacePrediction> pickUpPlacePredictionList = [];
List<PlacePrediction> dropOffPlacePredictionList = [];
TextEditingController pickUpController = TextEditingController();
TextEditingController dropOffController = TextEditingController();
TextEditingController priceController = TextEditingController();
TextEditingController numOfPassengersController = TextEditingController();
TextEditingController rideDescriptionController = TextEditingController();
List<LatLng> pLineCoordinates = [];
Set<Polyline> polylineSet = {};
LatLngBounds latLngBounds;
Set<Marker> markersSet = {};
Set<Circle> circlesSet = {};
List<String> _stopOvers = [];
TextEditingController stopOverController = TextEditingController();
List<PlacePrediction> stopOverPredictionList = [];
DirectionsDetails directionsDetails;

class _OfferRideScreenState extends State<OfferRideScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isValid = true;
  bool isDate = true;
  bool isTime = true;

  DateTime _selectedDate;
  TimeOfDay _selectedTime;
  int _numOfPassengers;
  String _rideDescription;
  String _price;

  List<Place> places;
  AutoCompleteTextField searchTextFieldFrom;
  AutoCompleteTextField searchTextFieldTo;
  GlobalKey<AutoCompleteTextFieldState<Place>> keyFrom = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<Place>> keyTo = new GlobalKey();

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadJsonData();
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

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2022),
      //execute when user chooses a date
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _selectedDate = value;
        isDate = true;
      });
    });
  }

  void _presentTimePicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _selectedTime = value;
        isTime = true;
      });
    });
  }

  Future<String> loadJsonData() async {
    var jsonText = await rootBundle.loadString('assets/places.json');
    final parsed = json.decode(jsonText).cast<Map<String, dynamic>>();
    setState(() =>
        places = parsed.map<Place>((json) => Place.fromJson(json)).toList());
    loading = false;
    // places = json.decode(jsonText).cast<Map<String, dynamic>>());
    print(places.first.place);
    return 'success';
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(getTranslated(context, "addstopovers")),
          content: SingleChildScrollView(
            child: ListBody(
              children: [DialogContent()],
            ),
          ),
          actions: [
            TextButton(
              child: getTitle(
                  title: getTranslated(context, "cancel"),
                  color: kPrimaryColor),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: getTitle(
                  title: getTranslated(context, "add"), color: kPrimaryColor),
              onPressed: () {
                setState(() {
                  _stopOvers.add(stopOverController.text);
                  stopOverController.text = "";
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
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

  callback(String pd) {
    setState(() {
      pickUpPlacePredictionList = [];
      dropOffPlacePredictionList = [];
      stopOverPredictionList = [];
      if (pd == "pick") {
        pickUpController.text = Provider.of<Address>(context, listen: false)
            .offerRidePickUpLocation
            .placeName;
      }
      if (pd == "drop") {
        dropOffController.text = Provider.of<Address>(context, listen: false)
            .offerRideDropOffLocation
            .placeName;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //print(data);
    var localizations = MaterialLocalizations.of(context).toString();
    var padding;
    setState(() {
      if (localizations.contains("En")) {
        padding = EdgeInsets.fromLTRB(0.0, 0.0, 64.0, 8.0);
      } else {
        padding = EdgeInsets.fromLTRB(64.0, 0.0, 0.0, 8.0);
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: getTitle(
            title: getTranslated(context, 'offrard'),
            color: kPrimaryColor,
            fontSize: 20),
      ),
      body: Card(
        elevation: 5,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: padding,
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Specify the initial location";
                              } else
                                return null;
                            },
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
                                        pickORdrop: "offer_pick",
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
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Specify the drop location";
                              } else
                                return null;
                            },
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
                                          pickORdrop: "offer_drop",
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
                                            .offerRidePickUpLocation ==
                                        null) ||
                                    (Provider.of<Address>(context,
                                                listen: false)
                                            .offerRideDropOffLocation ==
                                        null)
                                ? {}
                                : await getPlaceDirection();
                            await Navigator.of(context).pushNamed(
                                MapScreen.routeName,
                                arguments: "offer_a_ride");
                          },
                          child: getTitle(
                              title: getTranslated(context, "directions"),
                              color: Colors.white,
                              fontSize: 14),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 8.0),
                          child: Container(
                            child: Row(
                              children: [
                                Icon(Icons.date_range, color: kPrimaryColor),
                                Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8)),
                                Text(_selectedDate == null
                                    ? ''
                                    : DateFormat('EEE, MMM d')
                                        .format(_selectedDate)),
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
                                      title:
                                          getTranslated(context, 'choosedate'),
                                      color: isDate
                                          ? Colors.grey[700]
                                          : ThemeData().errorColor,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0, 8.0),
                          child: Container(
                            child: Row(
                              children: [
                                Icon(Icons.access_time_rounded,
                                    color: kPrimaryColor),
                                Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8)),
                                Text(_selectedTime == null
                                    ? ''
                                    : MaterialLocalizations.of(context)
                                        .formatTimeOfDay(_selectedTime)),
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
                                  onPressed: _presentTimePicker,
                                  child: getTitle(
                                      title:
                                          getTranslated(context, 'choosetime'),
                                      color: isTime
                                          ? Colors.grey[700]
                                          : ThemeData().errorColor,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: padding,
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Specify the number of passengers";
                              } else if (int.parse(value) > 7 ||
                                  int.parse(value) < 1) {
                                return "Passengers must be between 1-7";
                              } else
                                return null;
                            },
                            controller: numOfPassengersController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              icon: Icon(Icons.person, color: kPrimaryColor),
                              labelText: getTranslated(context, 'numofpass'),
                            ),
                            onChanged: (value) {
                              _numOfPassengers = int.parse(value);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Container(
                                  child: TextFormField(
                                    controller: priceController,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Specify the price";
                                      } else if (int.parse(value) > 50 ||
                                          int.parse(value) < 1) {
                                        return "Price range 1-50";
                                      } else
                                        return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      icon: Icon(Icons.monetization_on,
                                          color: kPrimaryColor),
                                      labelText:
                                          getTranslated(context, 'price'),
                                    ),
                                    onChanged: (value) {
                                      _price = value;
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(getTranslated(context, 'nis')),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: padding,
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                            getTranslated(context, 'stopovers'),
                                            style: blueSubHeadingTextStyle)),
                                    if (_stopOvers.isNotEmpty)
                                      SizedBox(
                                        height: 80.0,
                                        child: ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            itemCount: _stopOvers.length,
                                            itemBuilder: (ctx, index) {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  getTitle(
                                                      title: _stopOvers[index]),
                                                ],
                                              );
                                            }),
                                      ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Container(
                                    height: 36.0,
                                    width: 36.0,
                                    child: FittedBox(
                                      child: FloatingActionButton(
                                        onPressed: () {
                                          _displayTextInputDialog(context);
                                        },
                                        child: Icon(
                                          Icons.add,
                                        ),
                                        backgroundColor: kPrimaryColor,
                                        elevation: 3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          ),
                        ),
                        Padding(
                          padding: padding,
                          child: TextFormField(
                            controller: rideDescriptionController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              icon: Icon(Icons.description_rounded,
                                  color: kPrimaryColor),
                              labelText: "Ride Description",
                            ),
                            onChanged: (value) {
                              _rideDescription = value;
                            },
                            textCapitalization: TextCapitalization.sentences,
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
                              isValid = _formKey.currentState.validate();
                              if (_selectedDate == null) {
                                setState(() {
                                  isDate = false;
                                  isValid = false;
                                });
                              }
                              if (_selectedTime == null) {
                                setState(() {
                                  isTime = false;
                                  isValid = false;
                                });
                              }

                              FocusScope.of(context).unfocus();
                              if (isValid) {
                                var firstname = await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(uid)
                                    .get()
                                    .then((value) => value.data()['firstName']);
                                var lastname = await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(uid)
                                    .get()
                                    .then((value) => value.data()['lastName']);

                                await FirebaseFirestore.instance
                                    .collection('rides')
                                    .doc(uid)
                                    .collection('userrides')
                                    .doc()
                                    .set({
                                  'startTime': MaterialLocalizations.of(context)
                                      .formatTimeOfDay(_selectedTime),
                                  'startLocation': pickUpController.text,
                                  'arrivalLocation': dropOffController.text,
                                  'numOfPassengers': _numOfPassengers,
                                  'date': DateFormat('EEE, MMM d')
                                      .format(_selectedDate),
                                  'price': _price,
                                  'stopovers': _stopOvers,
                                  'driver': uid,
                                  'description': _rideDescription,
                                }).then((_) async {
                                  setState(() {
                                    _selectedDate = null;
                                    _selectedTime = null;
                                    priceController.clear();
                                    numOfPassengersController.clear();
                                    rideDescriptionController.clear();
                                    dropOffController.clear();
                                    pickUpController.clear();
                                    _stopOvers.clear();
                                    _rideDescription = null;
                                  });
                                  await showDialog(
                                    context: context,
                                    builder: (context) => new AlertDialog(
                                      title: new Text('Success!'),
                                      content: Text(
                                          'You offered a new ride successfully.'),
                                      actions: [
                                        new TextButton(
                                          onPressed: () {
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop(); // dismisses only the dialog and returns nothing
                                          },
                                          child: new Text('OK'),
                                        ),
                                      ],
                                    ),
                                  ).catchError((onError) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(onError)));
                                  });
                                });
                              }
                            },
                            child: getTitle(
                                title: getTranslated(context, 'offernewride'),
                                color: Colors.white,
                                fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
        Provider.of<Address>(context, listen: false).offerRidePickUpLocation;
    var finalPos =
        Provider.of<Address>(context, listen: false).offerRideDropOffLocation;

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

class DialogContent extends StatefulWidget {
  @override
  _DialogContentState createState() => _DialogContentState();
}

class _DialogContentState extends State<DialogContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        children: [
          TextField(
            controller: stopOverController,
            decoration:
                InputDecoration(hintText: getTranslated(context, "stopover")),
            onChanged: (value) {
              setState(() {
                findLocation(value);
              });
            },
          ),
          (stopOverPredictionList.length > 0)
              ? Padding(
                  padding: EdgeInsets.zero,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: ListView.separated(
                        padding: EdgeInsets.all(5),
                        itemBuilder: (context, index) {
                          //return Text("data");
                          return PredictionTile(
                              placePrediction: stopOverPredictionList[index],
                              callback: callback);
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(),
                        itemCount: stopOverPredictionList.length,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics()),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  void findLocation(String placeName) async {
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
          stopOverPredictionList = placesList;
          print(stopOverPredictionList.length);
        });
      }
      print(response);
    }
  }

  callback(String pd) {
    setState(() {
      stopOverPredictionList = [];
      if (pd == "stop") {
        stopOverController.text = Provider.of<Address>(context, listen: false)
            .stopOverLocation
            .placeName;
      }
    });
  }
}
