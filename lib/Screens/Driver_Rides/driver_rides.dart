import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/Screens/Driver_Rides/requests.dart';
import 'package:easy_ride/components/custom_container.dart';
import 'package:easy_ride/components/custom_elevated_button.dart';
import 'package:easy_ride/components/main_drawer.dart';
import 'package:easy_ride/models/ride.dart';
import 'package:easy_ride/models/searched_ride.dart';
import 'package:easy_ride/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class DriverRides extends StatefulWidget {
  static const routeName = '/driverrides';
  final List<Ride> driverRides;
  const DriverRides({Key key, this.driverRides}) : super(key: key);

  @override
  _DriverRidesState createState() => _DriverRidesState();
}

class _DriverRidesState extends State<DriverRides> {
  var backBtnRes;
  @override
  Widget build(BuildContext context) {
    List<SearchedRide> requests = [];
    List<User> users = [];
    List<String> status = ['pending', 'accepted'];
    return Scaffold(
        appBar: AppBar(
          title: getTitle(title: "My Rides", color: redColor, fontSize: 20),
          backgroundColor: Colors.white,
        ),
        body: ListView.builder(
          itemCount: widget.driverRides.length,
          itemBuilder: (ctx, index) {
            return CustomContainer(
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
                            "${widget.driverRides[index].price}₪",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    title: getTitle(
                        title:
                            "From ${widget.driverRides[index].startLocation}, \nTo ${widget.driverRides[index].arrivalLocation}",
                        color: Colors.brown[500],
                        fontSize: 16),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: widget.driverRides[index].stopOvers.length == 0 &&
                              widget.driverRides[index].description == null
                          ? Text(
                              "Number of seats left: ${widget.driverRides[index].numOfPassengers}\n\nDate: ${widget.driverRides[index].date}\n\nTime: ${widget.driverRides[index].startTime}",
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 14),
                            )
                          : widget.driverRides[index].stopOvers.length > 0 &&
                                  widget.driverRides[index].description == null
                              ? Text(
                                  "Number of seats left: ${widget.driverRides[index].numOfPassengers} \n\nDate: ${widget.driverRides[index].date}\n\nTime: ${widget.driverRides[index].startTime}\n\nStopovers: \n${widget.driverRides[index].stopOvers.where((item) => item.contains('')).join('\n')}",
                                  style: TextStyle(
                                      color: Colors.blueGrey, fontSize: 14),
                                )
                              : widget.driverRides[index].stopOvers.length ==
                                          0 &&
                                      widget.driverRides[index].description !=
                                          null
                                  ? Text(
                                      "Number of seats left: ${widget.driverRides[index].numOfPassengers} \n\nDate: ${widget.driverRides[index].date}\n\nTime: ${widget.driverRides[index].startTime}\n\nAdditional info: ${widget.driverRides[index].description}",
                                      style: TextStyle(
                                          color: Colors.blueGrey, fontSize: 14),
                                    )
                                  : Text(
                                      "Number of seats left: ${widget.driverRides[index].numOfPassengers} \n\nDate: ${widget.driverRides[index].date}\n\nTime: ${widget.driverRides[index].startTime}\n\nStopovers: \n${widget.driverRides[index].stopOvers.where((item) => item.contains('')).join('\n')}\n\nAdditional info: ${widget.driverRides[index].description}",
                                      style: TextStyle(
                                          color: Colors.blueGrey, fontSize: 14),
                                    ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomElevatedButton(
                        backgroundColor: redColor,
                        title: "Requests",
                        color: Colors.white,
                        onPressed: () async {
                          requests.clear();
                          users.clear();
                          await FirebaseFirestore.instance
                              .collection('requests')
                              .where('ride',
                                  isEqualTo: widget.driverRides[index].id)
                              .where('status', whereIn: status)
                              .get()
                              .then((query) {
                            query.docs.forEach((result) async {
                              await FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(result.data()['user'])
                                  .get()
                                  .then((value) {
                                User user = new User();
                                user.firstName = value.data()["firstName"];
                                user.lastName = value.data()["lastName"];
                                user.urlAvatar = value.data()["urlAvatar"];
                                users.add(user);
                                print(users.length);
                                requests.add(
                                  new SearchedRide(
                                    currentUser: result.data()['user'],
                                    date: result.data()['date'],
                                    pickUpLocation:
                                        result.data()['startLocation'],
                                    numOfPassengers:
                                        result.data()['numOfPassengers'],
                                    ride: result.id,
                                    status: result.data()['status'],
                                  ),
                                );
                              });
                            });
                          }).then((_) {
                            Future.delayed(const Duration(milliseconds: 500))
                                .then((_) {
                              showCupertinoModalPopup(
                                context: ctx,
                                builder: (_) {
                                  print(requests.length);
                                  return RideRequests(requests, users,
                                      widget.driverRides[index]);
                                },
                              ).then((value) => setState(() {
                                    backBtnRes = value;
                                    widget.driverRides[index].numOfPassengers =
                                        backBtnRes;
                                  }));
                            }).onError((error, stackTrace) => null);
                          });
                        },
                      ),
                      CustomElevatedButton(
                        backgroundColor: redColor,
                        title: "Delete Ride",
                        color: Colors.white,
                        onPressed: () async {
                          await showDialog(
                            context: context,
                            builder: (context) => new AlertDialog(
                              title: new Text('Confirmation!'),
                              content: Text(
                                  'Are you sure you want to delete this ride?'),
                              actions: [
                                new TextButton(
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
                                  },
                                  child: new Text('Cancel'),
                                ),
                                new TextButton(
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('rides')
                                        .doc(widget.driverRides[index].driver)
                                        .collection("userrides")
                                        .doc(widget.driverRides[index].id)
                                        .delete()
                                        .then((value) {
                                      setState(() {
                                        widget.driverRides.removeAt(index);
                                      });
                                    });
                                    Navigator.of(context, rootNavigator: true)
                                        .pop();
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
                ],
              ),
            );
          },
        ));
  }
}
