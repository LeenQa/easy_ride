import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/Screens/Driver_Rides/driver_rides.dart';
import 'package:easy_ride/Screens/Profile/profile_screen.dart';
import 'package:easy_ride/components/custom_elevated_button.dart';
import 'package:easy_ride/components/main_drawer.dart';
import 'package:easy_ride/components/rounded_input_field.dart';
import 'package:easy_ride/constants.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:easy_ride/models/ride.dart';
import 'package:easy_ride/models/searched_ride.dart';
import 'package:easy_ride/models/user.dart';
import 'package:flutter/material.dart';

import '../../text_style.dart';

class RideRequests extends StatefulWidget {
  final List<SearchedRide> rideRequests;
  final List<User> users;
  final Ride driverRide;
  RideRequests(this.rideRequests, this.users, this.driverRide);
  @override
  _RideRequestsState createState() => _RideRequestsState();
}

class _RideRequestsState extends State<RideRequests> {
  khara() {
    ;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, widget.driverRide.numOfPassengers);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Ride Requests"),
          backgroundColor: Colors.white,
        ),
        body: widget.rideRequests.length == 0
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "No requests yet!",
                    style: blueSubHeadingTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.all(10.0),
                        itemCount: widget.rideRequests.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  ProfileScreen.routeName,
                                  arguments: {
                                    'id':
                                        widget.rideRequests[index].currentUser,
                                    'name': widget.users[index].firstName +
                                        " " +
                                        widget.users[index].lastName,
                                    'urlAvatar': widget.users[index].urlAvatar,
                                    'isMe': false,
                                  });
                            },
                            child: Column(
                              children: [
                                ListTile(
                                  key: new Key(index.toString()),
                                  leading: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                        widget.users[index].urlAvatar),
                                  ),
                                  title: getTitle(
                                      fontSize: 18,
                                      title: widget.users[index].firstName +
                                          " " +
                                          widget.users[index].lastName,
                                      color: Colors.black,
                                      decoration: TextDecoration.underline),
                                ),
                                getTitle(
                                    title:
                                        "Meeting point: ${widget.rideRequests[index].pickUpLocation}",
                                    fontSize: 16,
                                    color: kPrimaryColor),
                                getTitle(
                                    title:
                                        "Number of passengers: ${widget.rideRequests[index].numOfPassengers}",
                                    fontSize: 16,
                                    color: kPrimaryColor),
                                widget.rideRequests[index].status == 'pending'
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02),
                                          IconButton(
                                            icon: Icon(Icons
                                                .check_circle_outline_rounded),
                                            onPressed: () async {
                                              widget.driverRide
                                                          .numOfPassengers >=
                                                      widget.rideRequests[index]
                                                          .numOfPassengers
                                                  ? await FirebaseFirestore
                                                      .instance
                                                      .collection('requests')
                                                      .doc(widget
                                                          .rideRequests[index]
                                                          .ride)
                                                      .update({
                                                      'status': 'accepted'
                                                    }).then((_) async {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('rides')
                                                          .doc(widget.driverRide
                                                              .driver)
                                                          .collection(
                                                              'userrides')
                                                          .doc(widget
                                                              .driverRide.id)
                                                          .update({
                                                        'numOfPassengers': widget
                                                                .driverRide
                                                                .numOfPassengers -
                                                            widget
                                                                .rideRequests[
                                                                    index]
                                                                .numOfPassengers
                                                      });
                                                      setState(() {
                                                        widget.driverRide
                                                                .numOfPassengers -=
                                                            widget
                                                                .rideRequests[
                                                                    index]
                                                                .numOfPassengers;
                                                        widget
                                                            .rideRequests[index]
                                                            .status = 'accepted';
                                                      });
                                                    })
                                                  : ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          backgroundColor:
                                                              Theme.of(context)
                                                                  .errorColor,
                                                          content: Text(
                                                              "Number of request passengers is bigger than left seats")));
                                            },
                                            iconSize: 45,
                                            color: Colors.green,
                                          ),
                                          IconButton(
                                              icon: Icon(Icons
                                                  .highlight_remove_rounded),
                                              onPressed: () async {
                                                await FirebaseFirestore.instance
                                                    .collection('requests')
                                                    .doc(widget
                                                        .rideRequests[index]
                                                        .ride)
                                                    .update({
                                                  'status': 'rejected'
                                                }).then((_) {
                                                  setState(() {
                                                    widget.users
                                                        .removeAt(index);
                                                    widget.rideRequests
                                                        .removeAt(index);
                                                  });
                                                });
                                              },
                                              iconSize: 45,
                                              color: Colors.red),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.05,
                                          ),
                                          Text(
                                            'Ride Accepted',
                                            style: blueSubHeadingTextStyle,
                                            textAlign: TextAlign.center,
                                          )
                                        ],
                                      ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider();
                        },
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
