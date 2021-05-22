import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/Screens/Search/components/multicity_input.dart';
import 'package:easy_ride/components/custom_container.dart';
import 'package:easy_ride/components/main_drawer.dart';
import 'package:easy_ride/constants.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:easy_ride/models/driver.dart';
import 'package:easy_ride/models/ride.dart';
import 'package:easy_ride/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                              child: getTitle(
                                title: "${rides[index].price}₪",
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        title: getTitle(
                            title:
                                "${getTranslated(context, "from")} ${rides[index].startLocation}, ${getTranslated(context, "to")} ${rides[index].arrivalLocation}",
                            color: Colors.brown[500],
                            fontSize: 14),
                        subtitle: getTitle(
                          title:
                              "${getTranslated(context, "numofseats")}: ${rides[index].numOfPassengers}",
                          color: Colors.blueGrey,
                          fontSize: 12,
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
      appBar: AppBar(
          title: getTitle(
              title: getTranslated(context, "rideslist"), fontSize: 20)),
      body: (exactRides.length == 0 && otherRides.length == 0)
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: getTitle(
                      title: getTranslated(context, "noridesfound"),
                      color: blueColor),
                ),
              ],
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  exactRides.length == 0
                      ? Container(
                          margin: EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Center(
                                child: getTitle(
                                    title:
                                        getTranslated(context, "nodirectrides"),
                                    color: blueColor),
                              ),
                            ],
                          ),
                        )
                      : CustomContainer(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ridesList(context, exactRides,
                                    getTranslated(context, "rideresults")),
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
                                ridesList(
                                    context,
                                    otherRides,
                                    getTranslated(
                                        context, "otherridesresults")),
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
