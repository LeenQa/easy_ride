import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:easy_ride/components/main_drawer.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:easy_ride/models/places.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

import '../../constants.dart';

class OfferRideScreen extends StatefulWidget {
  static const routeName = '/offer_ride';

  @override
  _OfferRideScreenState createState() => _OfferRideScreenState();
}

class _OfferRideScreenState extends State<OfferRideScreen> {
  String _fromChosenValue;
  String _toChosenValue;
  DateTime _selectedDate;
  TimeOfDay _selectedTime;
  String _numOfPassengers;

  List<Place> places;
  AutoCompleteTextField searchTextFieldFrom;
  AutoCompleteTextField searchTextFieldTo;
  GlobalKey<AutoCompleteTextFieldState<Place>> keyFrom = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<Place>> keyTo = new GlobalKey();

  bool loading = true;

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
        title: Text(getTranslated(context, 'offrard')),
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: padding,
                    child: loading
                        ? CircularProgressIndicator()
                        : searchTextFieldFrom = AutoCompleteTextField<Place>(
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
                              setState(() {
                                searchTextFieldFrom.textField.controller.text =
                                    item.place;
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
                        : searchTextFieldTo = AutoCompleteTextField<Place>(
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
                              setState(() {
                                searchTextFieldTo.textField.controller.text =
                                    item.place;
                              });
                            },
                            itemBuilder: (context, item) {
                              return row(item);
                            },
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 8.0),
                    child: Container(
                      child: Row(
                        children: [
                          Icon(Icons.date_range, color: kPrimaryColor),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 8)),
                          Text(_selectedDate == null
                              ? ''
                              : DateFormat('EEE, MMM d').format(_selectedDate)),
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
                                title: getTranslated(context, 'choosedate'),
                                color: Colors.grey[700],
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
                          Icon(Icons.access_time_rounded, color: kPrimaryColor),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 8)),
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
                                title: getTranslated(context, 'choosetime'),
                                color: Colors.grey[700],
                                fontSize: 14),
                          ),
                        ],
                      ),
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
                        _numOfPassengers = value;
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
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                icon: Icon(Icons.monetization_on,
                                    color: kPrimaryColor),
                                labelText: getTranslated(context, 'price'),
                              ),
                              onChanged: (value) {
                                _numOfPassengers = value;
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Expanded(
                          child: Text(getTranslated(context, 'nis')),
                        ),
                      ],
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
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          )),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20)),
                          textStyle: MaterialStateProperty.all(
                              TextStyle(fontSize: 30))),
                      onPressed: () {
                        /*  setState(() {
                          results = Search(searched.startLocation,
                              searched.arrivalLocation, _selectedDate, rides);
                        }); */
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
        ),
      ),
    );
  }
}
