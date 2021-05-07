import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/Screens/Driver_Rides/requests.dart';
import 'package:easy_ride/Screens/Profile/profile_screen.dart';
import 'package:easy_ride/components/custom_container.dart';
import 'package:easy_ride/components/custom_elevated_button.dart';
import 'package:easy_ride/components/main_drawer.dart';
import 'package:easy_ride/models/ride.dart';
import 'package:easy_ride/models/searched_ride.dart';
import 'package:easy_ride/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';
import '../../text_style.dart';

class UserRides extends StatefulWidget {
  static const routeName = '/userrides';
  final List<Ride> userRidesDetails;
  final List<SearchedRide> userRides;
  final List<User> drivers;
  const UserRides(
      {Key key, this.userRidesDetails, this.userRides, this.drivers})
      : super(key: key);

  @override
  _UserRidesState createState() => _UserRidesState();
}

Widget driverProfile(User driver, Ride ride, BuildContext ctx) {
  return GestureDetector(
    onTap: () {
      Navigator.of(ctx).pushNamed(ProfileScreen.routeName, arguments: {
        'id': ride.driver,
        'name': driver.firstName + " " + driver.lastName,
        'urlAvatar': driver.urlAvatar,
        'isMe': false,
      });
    },
    child: Text("Driver: " + driver.firstName + " " + driver.lastName,
        style: TextStyle(
            color: Colors.blueGrey,
            fontSize: 14,
            decoration: TextDecoration.underline)),
  );
}

class _UserRidesState extends State<UserRides> {
  var backBtnRes;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: getTitle(
              title: "My Requested Rides", color: redColor, fontSize: 20),
          backgroundColor: Colors.white,
        ),
        body: widget.userRides.length == 0
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "You haven't requested any ride yet!",
                    style: redSubHeadingTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            : ListView.builder(
                itemCount: widget.userRides.length,
                itemBuilder: (ctx, index) {
                  return CustomContainer(
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 10),
                          leading: CircleAvatar(
                            backgroundColor: redColor,
                            radius: 30,
                            child: Padding(
                              padding: EdgeInsets.all(0),
                              child: FittedBox(
                                child: Text(
                                  "${widget.userRidesDetails[index].price}₪",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          title: getTitle(
                              title:
                                  "From ${widget.userRidesDetails[index].startLocation}, \nTo ${widget.userRidesDetails[index].arrivalLocation}",
                              color: Colors.brown[500],
                              fontSize: 16),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: widget.userRidesDetails[index].stopOvers
                                            .length ==
                                        0 &&
                                    widget.userRidesDetails[index]
                                            .description ==
                                        null
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      driverProfile(widget.drivers[index],
                                          widget.userRidesDetails[index], ctx),
                                      Text(
                                        "\nStatus: ${widget.userRides[index].status}\n\nNumber of requested seats: ${widget.userRides[index].numOfPassengers}\n\nMeeting Point: ${widget.userRides[index].pickUpLocation}\n\nDate: ${widget.userRidesDetails[index].date}\n\nTime: ${widget.userRidesDetails[index].startTime}",
                                        style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 14),
                                      ),
                                    ],
                                  )
                                : widget.userRidesDetails[index].stopOvers
                                                .length >
                                            0 &&
                                        widget.userRidesDetails[index]
                                                .description ==
                                            null
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          driverProfile(
                                              widget.drivers[index],
                                              widget.userRidesDetails[index],
                                              ctx),
                                          Text(
                                            "\nStatus: ${widget.userRides[index].status}\n\nNumber of requested seats: ${widget.userRides[index].numOfPassengers}\n\nMeeting Point: ${widget.userRides[index].pickUpLocation}\n\nDate: ${widget.userRidesDetails[index].date}\n\nTime: ${widget.userRidesDetails[index].startTime}\n\nStopovers: \n${widget.userRidesDetails[index].stopOvers.where((item) => item.contains('')).join('\n')}",
                                            style: TextStyle(
                                                color: Colors.blueGrey,
                                                fontSize: 14),
                                          ),
                                        ],
                                      )
                                    : widget.userRidesDetails[index].stopOvers
                                                    .length ==
                                                0 &&
                                            widget.userRidesDetails[index]
                                                    .description !=
                                                null
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              driverProfile(
                                                  widget.drivers[index],
                                                  widget
                                                      .userRidesDetails[index],
                                                  ctx),
                                              Text(
                                                "\nStatus: ${widget.userRides[index].status}\n\nNumber of requested seats: ${widget.userRides[index].numOfPassengers}\n\nMeeting Point: ${widget.userRides[index].pickUpLocation}\n\nDate: ${widget.userRidesDetails[index].date}\n\nTime: ${widget.userRidesDetails[index].startTime}\n\nAdditional info: ${widget.userRidesDetails[index].description}",
                                                style: TextStyle(
                                                    color: Colors.blueGrey,
                                                    fontSize: 14),
                                              ),
                                            ],
                                          )
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              driverProfile(
                                                  widget.drivers[index],
                                                  widget
                                                      .userRidesDetails[index],
                                                  ctx),
                                              Text(
                                                "\nStatus: ${widget.userRides[index].status}\n\nNumber of requested seats: ${widget.userRides[index].numOfPassengers}\n\nMeeting Point: ${widget.userRides[index].pickUpLocation}\n\nDate: ${widget.userRidesDetails[index].date}\n\nTime: ${widget.userRidesDetails[index].startTime}\n\nStopovers: \n${widget.userRidesDetails[index].stopOvers.where((item) => item.contains('')).join('\n')}\n\nAdditional info: ${widget.userRidesDetails[index].description}",
                                                style: TextStyle(
                                                    color: Colors.blueGrey,
                                                    fontSize: 14),
                                              ),
                                            ],
                                          ),
                          ),
                        ),
                        CustomElevatedButton(
                          backgroundColor: redColor,
                          title: "Delete",
                          color: Colors.white,
                          onPressed: () async {
                            DateTime now = DateTime.now();
                            DateTime rideDate = new DateFormat('EEE, MMM d')
                                .parse(widget.userRides[index].date);
                            if (widget.userRides[index].status == "pending") {
                              await showDialog(
                                context: context,
                                builder: (context) => new AlertDialog(
                                  title: new Text('Confirmation!'),
                                  content: Text(
                                      'Are you sure you want to delete this ride request?'),
                                  actions: [
                                    new TextButton(
                                      onPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      },
                                      child: new Text('Cancel'),
                                    ),
                                    new TextButton(
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('requests')
                                            .doc(
                                                widget.userRides[index].request)
                                            .delete()
                                            .then((value) {
                                          setState(() {
                                            widget.drivers.removeAt(index);
                                            widget.userRides.removeAt(index);
                                            widget.userRidesDetails
                                                .removeAt(index);
                                          });
                                        });
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      },
                                      /*  */

                                      child: new Text('Confirm'),
                                    ),
                                  ],
                                ),
                              ).catchError((onError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(onError)));
                              });
                            } else if (widget.userRides[index].status ==
                                        "accepted" &&
                                    rideDate.month > now.month ||
                                (rideDate.day >= now.day &&
                                    rideDate.month == now.month)) {
                              await showDialog(
                                context: context,
                                builder: (context) => new AlertDialog(
                                  title: new Text('Confirmation!'),
                                  content: Text(
                                      'Are you sure you want to delete this ride request? It has been already accepted'),
                                  actions: [
                                    new TextButton(
                                      onPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      },
                                      child: new Text('Cancel'),
                                    ),
                                    new TextButton(
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('requests')
                                            .doc(
                                                widget.userRides[index].request)
                                            .delete()
                                            .then((value) async {
                                          await FirebaseFirestore.instance
                                              .collection('rides')
                                              .doc(widget
                                                  .userRidesDetails[index]
                                                  .driver)
                                              .collection('userrides')
                                              .doc(widget.userRides[index].ride)
                                              .update({
                                            'numOfPassengers': widget
                                                    .userRidesDetails[index]
                                                    .numOfPassengers +
                                                widget.userRides[index]
                                                    .numOfPassengers
                                          });
                                          setState(() {
                                            widget.drivers.removeAt(index);
                                            widget.userRides.removeAt(index);
                                            widget.userRidesDetails
                                                .removeAt(index);
                                          });
                                        });
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      },
                                      child: new Text('Confirm'),
                                    ),
                                  ],
                                ),
                              ).catchError((onError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(onError)));
                              });
                            } else {
                              await showDialog(
                                context: context,
                                builder: (context) => new AlertDialog(
                                  title: new Text('Confirmation!'),
                                  content: Text(
                                      'Do you want to delete this ride request?'),
                                  actions: [
                                    new TextButton(
                                      onPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      },
                                      child: new Text('Cancel'),
                                    ),
                                    new TextButton(
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('requests')
                                            .doc(
                                                widget.userRides[index].request)
                                            .delete()
                                            .then((value) {
                                          setState(() {
                                            widget.drivers.removeAt(index);
                                            widget.userRides.removeAt(index);
                                            widget.userRidesDetails
                                                .removeAt(index);
                                          });
                                        });
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      },
                                      /*  */

                                      child: new Text('Confirm'),
                                    ),
                                  ],
                                ),
                              ).catchError((onError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(onError)));
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              ));
  }
}
