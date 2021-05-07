import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/Screens/Profile/profile_screen.dart';
import 'package:easy_ride/Screens/Search/components/multicity_input.dart';
import 'package:easy_ride/components/custom_container.dart';
import 'package:easy_ride/components/custom_elevated_button.dart';
import 'package:easy_ride/components/main_drawer.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:easy_ride/models/driver.dart';
import 'package:easy_ride/models/ride.dart';
import 'package:easy_ride/models/searched_ride.dart';
import 'package:easy_ride/models/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';

class RideDetails extends StatelessWidget {
  final Ride ride;
  final Driver driver;

  const RideDetails({Key key, this.ride, this.driver}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: getTitle(
              title: getTranslated(context, 'ridedetails'),
              color: redColor,
              fontSize: 20),
          backgroundColor: Colors.white,
        ),
        body: CustomContainer(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  leading: CircleAvatar(
                    backgroundColor: redColor,
                    radius: 30,
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child: FittedBox(
                        child: Text(
                          "${ride.price}₪",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  title: getTitle(
                      title:
                          "From ${ride.startLocation}, \nTo ${ride.arrivalLocation}",
                      color: Colors.brown[500],
                      fontSize: 16),
                  subtitle: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: ride.stopOvers.length == 0
                          ? Text(
                              "Number of seats left: ${ride.numOfPassengers}\n\nDate: ${ride.date}\n\nTime: ${ride.startTime}",
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 14),
                            )
                          : Text(
                              "Number of seats left: ${ride.numOfPassengers} \n\nDate: ${ride.date}\n\nTime: ${ride.startTime}\n\nStopovers: \n${ride.stopOvers.where((item) => item.contains('')).join('\n')}",
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 14),
                            )),
                ),
                ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                  leading: CircleAvatar(
                    backgroundColor: redColor,
                    radius: 30,
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child: FittedBox(
                        child: Icon(
                          Icons.drive_eta,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  title: InkWell(
                    onTap: () async {
                      var isDriver = await FirebaseFirestore.instance
                          .collection("drivers")
                          .doc(ride.driver)
                          .get();
                      Navigator.of(context)
                          .pushNamed(ProfileScreen.routeName, arguments: {
                        'id': ride.driver,
                        'name':
                            driver.user.firstName + " " + driver.user.lastName,
                        'urlAvatar': driver.user.urlAvatar,
                        'isMe': searchedRide.currentUser == ride.driver
                            ? true
                            : false,
                        'isDriver': isDriver.exists
                      });
                    },
                    child: getTitle(
                        title:
                            "Driver: ${driver.user.firstName} ${driver.user.lastName}",
                        color: Colors.brown[500],
                        fontSize: 16,
                        decoration: TextDecoration.underline),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: ride.description == null
                        ? Text(
                            //"Notes: ${ride.driver.setOfRules[0]}, ${ride.driver.setOfRules[1]}.\n\nCar Model: ${ride.driver.carModel}\n\nStopovers: ${ride.stopOvers[0]}, ${ride.stopOvers[1]}",
                            "Car Model: ${driver.carModel}",
                            style:
                                TextStyle(color: Colors.blueGrey, fontSize: 14),
                          )
                        : Text(
                            //"Notes: ${ride.driver.setOfRules[0]}, ${ride.driver.setOfRules[1]}.\n\nCar Model: ${ride.driver.carModel}\n\nStopovers: ${ride.stopOvers[0]}, ${ride.stopOvers[1]}",
                            "Car Model: ${driver.carModel}\n\nAdditional info: ${ride.description}",
                            style:
                                TextStyle(color: Colors.blueGrey, fontSize: 14),
                          ),
                  ),
                ),
                CustomElevatedButton(
                  backgroundColor: redColor,
                  title: getTranslated(context, 'requestride'),
                  color: Colors.white,
                  onPressed: () async {
                    searchedRide.currentUser == ride.driver
                        ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Theme.of(context).errorColor,
                            content: Text("You can't request your own rides")))
                        : await showDialog(
                            context: context,
                            builder: (context) => new AlertDialog(
                              title: new Text('Confirmation!'),
                              content: Text(
                                  'Are you sure you want to request this ride?'),
                              actions: [
                                new TextButton(
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop(); // dismisses only the dialog and returns nothing
                                  },
                                  child: new Text('Cancel'),
                                ),
                                new TextButton(
                                  onPressed: () async {
                                    bool isRequested = false;
                                    await FirebaseFirestore.instance
                                        .collection('requests')
                                        .where("ride", isEqualTo: ride.id)
                                        .where("user",
                                            isEqualTo: searchedRide.currentUser)
                                        .get()
                                        .then((value) {
                                      if (value.size > 0) isRequested = true;
                                    });
                                    if (!isRequested) {
                                      String id = FirebaseFirestore.instance
                                          .collection('requests')
                                          .doc()
                                          .id;
                                      await FirebaseFirestore.instance
                                          .collection('requests')
                                          .doc(id)
                                          .set({
                                        'startLocation':
                                            searchedRide.pickUpLocation,
                                        'arrivalLocation':
                                            searchedRide.dropOffLocation,
                                        'numOfPassengers':
                                            searchedRide.numOfPassengers,
                                        'date': searchedRide.date,
                                        'user': searchedRide.currentUser,
                                        'ride': ride.id,
                                        'status': 'pending',
                                      }).then((_) async {
                                        List requests = [];
                                        await FirebaseFirestore.instance
                                            .collection('rides')
                                            .doc(ride.driver)
                                            .collection('userrides')
                                            .doc(ride.id)
                                            .get()
                                            .then((value) {
                                          if (requests.isEmpty) {
                                          } else
                                            requests = value.data()['requests'];
                                        }).then((_) async {
                                          requests.add(id);
                                          await FirebaseFirestore.instance
                                              .collection('rides')
                                              .doc(ride.driver)
                                              .collection('userrides')
                                              .doc(ride.id)
                                              .update({'requests': requests});
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              backgroundColor: Colors.green,
                                              content: Text(
                                                  "Your request has been sent successfully!"),
                                            ),
                                          );
                                        });
                                      });
                                    } else {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor:
                                              Theme.of(context).errorColor,
                                          content: Text(
                                              "Your already sent a request for this ride!"),
                                        ),
                                      );
                                    }
                                  },
                                  child: new Text('Confirm'),
                                ),
                              ],
                            ),
                          ).catchError((onError) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(onError)));
                          });
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
