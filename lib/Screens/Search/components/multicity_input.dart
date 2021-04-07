import 'dart:convert';

import 'package:easy_ride/components/info_container.dart';
import 'package:easy_ride/components/main_drawer.dart';
import 'package:easy_ride/components/rides_list.dart';
import 'package:easy_ride/constants.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:easy_ride/models/driver.dart';
import 'package:easy_ride/models/places.dart';
import 'package:easy_ride/models/ride.dart';
import 'package:easy_ride/models/user.dart' as User;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class MulticityInput extends StatefulWidget {
  @override
  _MulticityInputState createState() => _MulticityInputState();
}

bool searchFound = false;

List<Ride> Search(String from, String to, DateTime time, List<Ride> rides) {
  List<Ride> matches = [];
  for (int i = 0; i < rides.length; i++) {
    print(rides[0].startLocation);
    if (rides[i].startLocation.toLowerCase().contains(from.toLowerCase()) &&
        rides[i].arrivalLocation.toLowerCase().contains(to.toLowerCase()) &&
        time.year == rides[i].date.year &&
        time.month == rides[i].date.month &&
        time.day == rides[i].date.day) {
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
  AutoCompleteTextField searchTextFieldFrom;
  AutoCompleteTextField searchTextFieldTo;
  GlobalKey<AutoCompleteTextFieldState<Place>> keyFrom = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<Place>> keyTo = new GlobalKey();

  bool loading = true;

  DateTime _selectedDate;
  Ride ride1 = new Ride(
    DateFormat('h:mm:ssa', 'en_US').parseLoose('2:00:00PM'),
    // DateFormat('h:mm:ssa', 'en_US').parseLoose('4:00:00PM'),
    "Bethlehem",
    "Ramallah",
    DateTime.now(),
    2,
    20.00,
    ["Jericho", "Ebediye"],
    new Driver(
      new User.User("email", "password", "Leen", "Qazaha", 059473232),
      "Alfa Romeo giulia",
      ["No smoking", "No pets"],
    ),
  );
  Ride ride2 = new Ride(
    DateFormat('h:mm:ssa', 'en_US').parseLoose('2:00:00PM'),
    // DateFormat('h:mm:ssa', 'en_US').parseLoose('4:00:00PM'),
    "Bethlehem",
    "Ramallah",
    DateTime.now(),
    2,
    20.00,
    ["Jericho", "Ebediye"],
    new Driver(
      new User.User("email", "password", "Leen", "Qazaha", 059473232),
      "Alfa Romeo giulia",
      ["No smoking", "No pets"],
    ),
  );
  Ride searched = Ride();
  List<Ride> results = [];
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

  @override
  void initState() {
    super.initState();
    loadJsonData();
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
                        Padding(
                          padding: padding,
                          child: loading
                              ? CircularProgressIndicator()
                              : searchTextFieldFrom =
                                  AutoCompleteTextField<Place>(
                                  key: keyFrom,
                                  clearOnSubmit: false,
                                  suggestions: places,
                                  decoration: new InputDecoration(
                                    icon: Icon(Icons.local_taxi_rounded,
                                        color: kPrimaryColor),
                                    labelText: getTranslated(context, 'from'),
                                  ),
                                  itemFilter: (item, query) {
                                    return item.place
                                        .toLowerCase()
                                        .startsWith(query.toLowerCase());
                                  },
                                  itemSorter: (a, b) {
                                    return a.place.compareTo(b.place);
                                  },
                                  itemSubmitted: (item) {
                                    searched.startLocation = item.place;
                                    setState(() {
                                      searchTextFieldFrom.textField.controller
                                          .text = item.place;
                                    });
                                  },
                                  itemBuilder: (context, item) {
                                    return row(item);
                                  },
                                ),
                        ),
                        Padding(
                          padding: padding,
                          child: loading
                              ? CircularProgressIndicator()
                              : searchTextFieldTo =
                                  AutoCompleteTextField<Place>(
                                  key: keyTo,
                                  clearOnSubmit: false,
                                  suggestions: places,
                                  decoration: new InputDecoration(
                                    icon: Icon(Icons.local_taxi_rounded,
                                        color: kPrimaryColor),
                                    labelText: getTranslated(context, 'to'),
                                  ),
                                  itemFilter: (item, query) {
                                    return item.place
                                        .toLowerCase()
                                        .startsWith(query.toLowerCase());
                                  },
                                  itemSorter: (a, b) {
                                    return a.place.compareTo(b.place);
                                  },
                                  itemSubmitted: (item) {
                                    searched.arrivalLocation = item.place;
                                    setState(() {
                                      searchTextFieldTo.textField.controller
                                          .text = item.place;
                                    });
                                  },
                                  itemBuilder: (context, item) {
                                    return row(item);
                                  },
                                ),
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
                              searched.numOfPassengers = value.toString();
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
                                  children: <Widget>[
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
                            onPressed: () {
                              setState(() {
                                results = Search(
                                    searched.startLocation,
                                    searched.arrivalLocation,
                                    _selectedDate,
                                    rides);
                                print(results.isEmpty);
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
}
