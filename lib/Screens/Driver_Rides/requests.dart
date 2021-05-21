import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/Assistants/assistantMethods.dart';
import 'package:easy_ride/Screens/Profile/profile_screen.dart';
import 'package:easy_ride/components/main_drawer.dart';
import 'package:easy_ride/components/return_message.dart';
import 'package:easy_ride/constants.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:easy_ride/models/ride.dart';
import 'package:easy_ride/models/searched_ride.dart';
import 'package:easy_ride/models/user.dart' as User;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../../text_style.dart';

class RideRequests extends StatefulWidget {
  final List<SearchedRide> rideRequests;
  final List<User.User> users;
  final Ride driverRide;
  RideRequests(this.rideRequests, this.users, this.driverRide);
  @override
  _RideRequestsState createState() => _RideRequestsState();
}

class _RideRequestsState extends State<RideRequests> {
  @override
  void initState() {
    super.initState();
    getUser();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  String uid;
  bool already;
  getUser() {
    uid = auth.currentUser.uid;
  }

  /* String driverFirstName = "";
  String driverLastName = "";
  String driverUrlAvatar = "";
  String token = "";
  bool areRequestsNotificationsTurnedOn = true;
  getDriverDetails(String uid, String driverFirstName, String driverLastName,
      String driverUrlAvatar) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((value) {
      driverFirstName = value.data()['firstName'];
      driverLastName = value.data()['lastName'];
      driverUrlAvatar = value.data()['urlAvatar'];
    });
  } */

  @override
  Widget build(BuildContext context) {
    print(uid);
    String driverFirstName = "";
    String driverLastName = "";
    String driverUrlAvatar = "";
    String token = "";
    bool areRequestsNotificationsTurnedOn = true;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, widget.driverRide.numOfPassengers);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: getTitle(
              title: getTranslated(context, "riderequests"), fontSize: 20),
          backgroundColor: Colors.white,
        ),
        body: widget.rideRequests.length == 0
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: getTitle(
                        title: getTranslated(context, "norequests"),
                        color: Colors.blue[400]),
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
                            onTap: () async {
                              var driver = await FirebaseFirestore.instance
                                  .collection("drivers")
                                  .doc(widget.rideRequests[index].currentUser)
                                  .get();

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
                                    'isDriver': driver.exists
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
                                        "${getTranslated(context, "meetingpoint")}: ${widget.rideRequests[index].pickUpLocation}",
                                    fontSize: 16,
                                    color: kPrimaryColor),
                                getTitle(
                                    title:
                                        "${getTranslated(context, "numofpass")}: ${widget.rideRequests[index].numOfPassengers}",
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
                                              DateTime now = DateTime.now();
                                              DateTime rideDate =
                                                  new DateFormat('EEE, MMM d')
                                                      .parse(widget
                                                          .rideRequests[index]
                                                          .date);
                                              print(rideDate.day);
                                              print(rideDate);
                                              print(now.day);
                                              print(now);
                                              if (rideDate.month > now.month ||
                                                  (rideDate.day >= now.day &&
                                                      rideDate.month ==
                                                          now.month)) {
                                                widget.driverRide.numOfPassengers >=
                                                        widget
                                                            .rideRequests[index]
                                                            .numOfPassengers
                                                    ? await FirebaseFirestore
                                                        .instance
                                                        .collection('requests')
                                                        .doc(widget
                                                            .rideRequests[index]
                                                            .request)
                                                        .update({'status': 'accepted'}).then(
                                                            (_) async {
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('rides')
                                                            .doc(widget
                                                                .driverRide
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
                                                        }).then((_) async {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'users')
                                                              .doc(uid)
                                                              .get()
                                                              .then((value) {
                                                            driverFirstName =
                                                                value.data()[
                                                                    'firstName'];
                                                            driverLastName =
                                                                value.data()[
                                                                    'lastName'];
                                                            driverUrlAvatar =
                                                                value.data()[
                                                                    'urlAvatar'];
                                                          });
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'users')
                                                              .doc(widget
                                                                  .rideRequests[
                                                                      index]
                                                                  .currentUser)
                                                              .get()
                                                              .then(
                                                                  (value) async {
                                                            token =
                                                                value.data()[
                                                                    'token'];

                                                            areRequestsNotificationsTurnedOn =
                                                                value.data()[
                                                                    'getRequestNotifications'];
                                                            if (token != '') {
                                                              print(token);
                                                              OneSignal.shared
                                                                  .setNotificationWillShowInForegroundHandler(
                                                                      (OSNotificationReceivedEvent
                                                                          event) {
                                                                event.complete(
                                                                    null);
                                                              });
                                                              if (areRequestsNotificationsTurnedOn) {
                                                                AssistantMethods.sendNotification(
                                                                    [token],
                                                                    getTranslated(
                                                                        context,
                                                                        "requestacceptnotif"),
                                                                    driverFirstName +
                                                                        " " +
                                                                        driverLastName,
                                                                    driverUrlAvatar);
                                                              }
                                                            }
                                                          });
                                                        });

                                                        setState(() {
                                                          widget.driverRide
                                                                  .numOfPassengers -=
                                                              widget
                                                                  .rideRequests[
                                                                      index]
                                                                  .numOfPassengers;
                                                          widget
                                                                  .rideRequests[
                                                                      index]
                                                                  .status =
                                                              'accepted';
                                                        });
                                                      })
                                                    : ScaffoldMessenger.of(context)
                                                        .showSnackBar(SnackBar(
                                                            backgroundColor:
                                                                Theme.of(context)
                                                                    .errorColor,
                                                            content: ReturnMessage.fail(
                                                                context,
                                                                getTranslated(
                                                                    context, "numofseatserror"))));
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        backgroundColor:
                                                            Theme.of(context)
                                                                .errorColor,
                                                        content: getTitle(
                                                            title: getTranslated(
                                                                context,
                                                                "oldrideerror"))));
                                              }
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
                                                        .request)
                                                    .update({
                                                  'status': 'rejected'
                                                }).then((_) async {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('rides')
                                                      .doc(widget
                                                          .driverRide.driver)
                                                      .collection('userrides')
                                                      .doc(widget.driverRide.id)
                                                      .update({
                                                    'numOfPassengers': widget
                                                            .driverRide
                                                            .numOfPassengers -
                                                        widget
                                                            .rideRequests[index]
                                                            .numOfPassengers
                                                  }).then((_) async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .doc(uid)
                                                        .get()
                                                        .then((value) {
                                                      driverFirstName = value
                                                          .data()['firstName'];
                                                      driverLastName = value
                                                          .data()['lastName'];
                                                      driverUrlAvatar = value
                                                          .data()['urlAvatar'];
                                                    });
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .doc(widget
                                                            .rideRequests[index]
                                                            .currentUser)
                                                        .get()
                                                        .then((value) async {
                                                      token =
                                                          value.data()['token'];

                                                      areRequestsNotificationsTurnedOn =
                                                          value.data()[
                                                              'getRequestNotifications'];
                                                      if (token != '') {
                                                        print(token);
                                                        OneSignal.shared
                                                            .setNotificationWillShowInForegroundHandler(
                                                                (OSNotificationReceivedEvent
                                                                    event) {
                                                          event.complete(null);
                                                        });
                                                        if (areRequestsNotificationsTurnedOn) {
                                                          AssistantMethods.sendNotification(
                                                              [token],
                                                              getTranslated(
                                                                  context,
                                                                  "riderejectnotif"),
                                                              driverFirstName +
                                                                  " " +
                                                                  driverLastName,
                                                              driverUrlAvatar);
                                                        }
                                                      }
                                                    });
                                                  });
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
                                    : Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.05,
                                              ),
                                              Center(
                                                child: getTitle(
                                                    title: getTranslated(
                                                        context,
                                                        "rideaccepted"),
                                                    color: Colors.blue[400]),
                                              )
                                            ],
                                          ),
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
