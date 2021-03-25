import 'package:easy_ride/components/custom_elevated_button.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:easy_ride/models/ride.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import 'custom_container.dart';
import 'main_drawer.dart';

class RideDetails extends StatelessWidget {
  final Ride ride;

  const RideDetails({Key key, this.ride}) : super(key: key);
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
                    child: Text(
                      "Number of seats left: ${ride.numOfPassengers} \n\nTime: 2:00:00PM",
                      style: TextStyle(color: Colors.blueGrey, fontSize: 14),
                    ),
                  ),
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
                  title: getTitle(
                      title:
                          "Driver: ${ride.driver.user.firstName} ${ride.driver.user.lastName}",
                      color: Colors.brown[500],
                      fontSize: 16),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      "Notes: ${ride.driver.setOfRules[0]}, ${ride.driver.setOfRules[1]}.\n\nCar Model: ${ride.driver.carModel}\n\nStopovers: ${ride.stopOvers[0]}, ${ride.stopOvers[1]}",
                      style: TextStyle(color: Colors.blueGrey, fontSize: 14),
                    ),
                  ),
                ),
                CustomElevatedButton(
                  backgroundColor: redColor,
                  title: getTranslated(context, 'requestride'),
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ));
  }
}
