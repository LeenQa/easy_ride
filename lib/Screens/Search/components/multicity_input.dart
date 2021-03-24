import 'package:easy_ride/components/info_container.dart';
import 'package:easy_ride/components/main_drawer.dart';
import 'package:easy_ride/components/rides_list.dart';
import 'package:easy_ride/constants.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:easy_ride/models/ride.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  DateTime _selectedDate;
  Ride ride1 = new Ride(
    DateFormat('h:mm:ssa', 'en_US').parseLoose('2:00:00PM'),
    DateFormat('h:mm:ssa', 'en_US').parseLoose('4:00:00PM'),
    "Bethlehem",
    "Ramallah",
    DateTime.now(),
    2,
    20.00,
    ["Jericho", "Ebediye"],
  );
  Ride ride2 = new Ride(
    DateFormat('h:mm:ssa', 'en_US').parseLoose('2:00:00PM'),
    DateFormat('h:mm:ssa', 'en_US').parseLoose('4:00:00PM'),
    "Bethlehem",
    "Ramallah",
    DateTime.now(),
    2,
    20.00,
    ["Jericho", "Ebediye"],
  );
  Ride searched = Ride();
  List<Ride> results = [];
  @override
  Widget build(BuildContext context) {
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
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 64.0, 8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              icon: Icon(Icons.local_taxi_rounded,
                                  color: kSecondaryColor),
                              labelText: getTranslated(context, 'from'),
                            ),
                            onChanged: (value) {
                              searched.startLocation = value;
                              print(searched.startLocation);
                            },
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 64.0, 8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              icon: Icon(Icons.local_taxi_rounded,
                                  color: kSecondaryColor),
                              labelText: getTranslated(context, 'to'),
                            ),
                            onChanged: (value) {
                              searched.arrivalLocation = value;
                            },
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 0.0, 64.0, 8.0),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              icon: Icon(Icons.person, color: kSecondaryColor),
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
                                        color: kSecondaryColor),
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
                                    return kSecondaryColor;
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
