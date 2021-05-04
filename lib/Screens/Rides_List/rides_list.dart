import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/Screens/Search/components/multicity_input.dart';
import 'package:easy_ride/components/custom_container.dart';
import 'package:easy_ride/components/main_drawer.dart';
import 'package:easy_ride/constants.dart';
import 'package:easy_ride/models/driver.dart';
import 'package:easy_ride/models/ride.dart';
import 'package:easy_ride/models/searched_ride.dart';
import 'package:easy_ride/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ride_details.dart';

class RidesList extends StatefulWidget {
  static const String routeName = "/rides_list";
  final List<Ride> transactions;
  final String title;

  const RidesList({
    Key key,
    this.transactions,
    this.title,
  }) : super(key: key);

  @override
  _RidesListState createState() => _RidesListState();
}

class _RidesListState extends State<RidesList> {
  Driver driver = new Driver();
  User user = new User();
  Future<void> _showRideDetails(BuildContext ctx, Ride ride) async {
    await FirebaseFirestore.instance
        .collection("drivers")
        .doc(ride.driver)
        .get()
        .then((value) async {
      driver.carModel = value.data()["carModel"];
      print(driver.carModel);
      print(value.data());

      await FirebaseFirestore.instance
          .collection("users")
          .doc(value.data()["user"])
          .get()
          .then((value) {
        driver.user = user;
        driver.user.firstName = value.data()["firstName"];
        driver.user.lastName = value.data()["lastName"];
        driver.user.urlAvatar = value.data()["urlAvatar"];
        print(driver.user.firstName);
      });
    });
    showCupertinoModalPopup(
      context: ctx,
      builder: (_) {
        return RideDetails(
          ride: ride,
          driver: driver,
        );
      },
    );
  }

  ridesList(BuildContext ctx, List<Ride> rides, String title) {
    int count = rides.length;
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.place,
              color: Colors.red,
            ),
            getTitle(title: title, color: Colors.black, fontSize: 16),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          width: double.infinity,
          // margin: EdgeInsets.all(2),
          height: MediaQuery.of(context).size.height * 0.30,

          child: ListView.builder(
            itemBuilder: (ctx, index) {
              return Column(
                children: [
                  Card(
                    // color: kCardColor,
                    elevation: 0,
                    // color: Color(0xfff1f4f9),
                    // margin: EdgeInsets.symmetric(
                    //   vertical: 8,
                    //   horizontal: 8,
                    // ),
                    child: InkWell(
                      onTap: () => _showRideDetails(context, rides[index]),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: kAccentColor,
                          radius: 30,
                          child: Padding(
                            padding: EdgeInsets.all(0),
                            child: FittedBox(
                              child: Text(
                                "${rides[index].price}₪",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        title: getTitle(
                            title:
                                "From ${rides[index].startLocation}, To ${rides[index].arrivalLocation}",
                            color: Colors.brown[500],
                            fontSize: 14),
                        subtitle: Text(
                          "Number of seats left: ${rides[index].numOfPassengers}",
                          style:
                              TextStyle(color: Colors.blueGrey, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    indent: 10,
                    endIndent: 10,
                  ),
                ],
              );
            },
            itemCount: count,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Rides List")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomContainer(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ridesList(context, exactRides, "Rides Found"),
                  ],
                ),
              ),
            ),
            otherRides.length == 0
                ? Container()
                : CustomContainer(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ridesList(context, otherRides, "Other Rides Found"),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
