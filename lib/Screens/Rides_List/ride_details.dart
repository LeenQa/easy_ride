import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/Assistants/assistantMethods.dart';
import 'package:easy_ride/Screens/Profile/profile_screen.dart';
import 'package:easy_ride/Screens/Search/components/multicity_input.dart';
import 'package:easy_ride/components/custom_container.dart';
import 'package:easy_ride/components/custom_elevated_button.dart';
import 'package:easy_ride/components/main_drawer.dart';
import 'package:easy_ride/components/return_message.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:easy_ride/models/driver.dart';
import 'package:easy_ride/models/ride.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

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
                        child: getTitle(
                          title: "${ride.price}₪",
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  title: getTitle(
                      title:
                          "${getTranslated(context, "from")} ${ride.startLocation}, \n${getTranslated(context, "to")} ${ride.arrivalLocation}",
                      color: Colors.brown[500],
                      fontSize: 16),
                  subtitle: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: ride.stopOvers.length == 0
                          ? getTitle(
                              title:
                                  "${getTranslated(context, "numofseats")}: ${ride.numOfPassengers}\n\n${getTranslated(context, "date")}: ${ride.date}\n\n${getTranslated(context, "time")}: ${ride.startTime}",
                              color: Colors.blueGrey,
                              fontSize: 14,
                            )
                          : getTitle(
                              title:
                                  "${getTranslated(context, "numofseats")}: ${ride.numOfPassengers} \n\n${getTranslated(context, "date")}: ${ride.date}\n\n${getTranslated(context, "time")}: ${ride.startTime}\n\n${getTranslated(context, "stopovers")} \n${ride.stopOvers.where((item) => item.contains('')).join('\n')}",
                              color: Colors.blueGrey,
                              fontSize: 14,
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
                            "${getTranslated(context, "driver")}: ${driver.user.firstName} ${driver.user.lastName}",
                        color: Colors.brown[500],
                        fontSize: 16,
                        decoration: TextDecoration.underline),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: ride.description == null
                        ? getTitle(
                            title:
                                //"Notes: ${ride.driver.setOfRules[0]}, ${ride.driver.setOfRules[1]}.\n\nCar Model: ${ride.driver.carModel}\n\nStopovers: ${ride.stopOvers[0]}, ${ride.stopOvers[1]}",
                                "${getTranslated(context, "carmodel")}: ${driver.carModel}",
                            color: Colors.blueGrey,
                            fontSize: 14,
                          )
                        : getTitle(
                            title:
                                //"Notes: ${ride.driver.setOfRules[0]}, ${ride.driver.setOfRules[1]}.\n\nCar Model: ${ride.driver.carModel}\n\nStopovers: ${ride.stopOvers[0]}, ${ride.stopOvers[1]}",
                                "${getTranslated(context, "carmodel")}: ${driver.carModel}\n\n${getTranslated(context, "additionalinfo")}: ${ride.description}",
                            color: Colors.blueGrey,
                            fontSize: 14,
                          ),
                  ),
                ),
                CustomElevatedButton(
                  backgroundColor: redColor,
                  title: getTranslated(context, 'requestride'),
                  color: Colors.white,
                  onPressed: () async {
                    searchedRide.currentUser == ride.driver
                        ? ReturnMessage.fail(
                            context, getTranslated(context, "ownrideerror"))
                        : await showDialog(
                            context: context,
                            builder: (context) => new AlertDialog(
                              title: getTitle(
                                  title:
                                      getTranslated(context, "confirmation")),
                              content: getTitle(
                                  title: getTranslated(
                                      context, "riderequestconf")),
                              actions: [
                                new TextButton(
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop(); // dismisses only the dialog and returns nothing
                                  },
                                  child: getTitle(
                                      title: getTranslated(context, "cancel")),
                                ),
                                new TextButton(
                                  onPressed: () async {
                                    String firstName = "";
                                    String lastName = "";
                                    String urlAvatar = "";
                                    String token = "";
                                    bool areRequestsNotificationsTurnedOn =
                                        true;
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
                                        'isReviewed': false,
                                      }).then((_) async {
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(ride.driver)
                                            .get()
                                            .then((value) async {
                                          token = value.data()['token'];

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
                                              await FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(searchedRide.currentUser)
                                                  .get()
                                                  .then((value) {
                                                firstName =
                                                    value.data()['firstName'];
                                                lastName =
                                                    value.data()['lastName'];
                                                urlAvatar =
                                                    value.data()['urlAvatar'];
                                                AssistantMethods
                                                    .sendNotification(
                                                        [token],
                                                        getTranslated(context,
                                                            "riderequestsent"),
                                                        firstName +
                                                            " " +
                                                            lastName,
                                                        urlAvatar);
                                              });
                                            }
                                          }
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                          ReturnMessage.success(
                                              context,
                                              getTranslated(context,
                                                  "requestsentsuccess"));
                                        });
                                      });
                                    } else {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                      ReturnMessage.fail(
                                          context,
                                          getTranslated(
                                              context, "requestalreadysent"));
                                    }
                                  },
                                  child: getTitle(
                                      title: getTranslated(context, "confirm")),
                                ),
                              ],
                            ),
                          ).catchError((onError) {
                            ReturnMessage.fail(context, onError);
                          });
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
