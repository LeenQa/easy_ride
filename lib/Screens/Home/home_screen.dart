import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/Screens/Become_Driver/become_driver_screen.dart';
import 'package:easy_ride/components/custom_elevated_button.dart';
import 'package:easy_ride/components/info_container.dart';
import 'package:easy_ride/constants.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:easy_ride/models/ride.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../components/main_drawer.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/homescreen";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getUser();
    checkDone();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  String uid;
  bool already;
  getUser() {
    final User user = auth.currentUser;
    uid = user.uid;
  }

  checkDone() async {
    var data = await FirebaseFirestore.instance
        .collection("driver_requests")
        .doc(uid)
        .get();
    print(data);
    if (data.exists) {
      already = true;
      print("true");
    } else {
      already = false;
      print("false");
    }
  }

  DateTime dateTime = DateFormat('h:mm:ssa', 'en_US').parseLoose('2:00:00AM');

  Ride ride1 = new Ride(
    "TimeOfDay.now()",
    // DateFormat('h:mm:ssa', 'en_US').parseLoose('4:00:00PM'),
    "Bethlehem",
    "Ramallah",
    "DateTime.now()",
    2,
    "20.00",
    ["Jericho", "Ebediye"],
  );

  Ride ride2 = new Ride(
    "TimeOfDay.now()",
    // DateFormat('h:mm:ssa', 'en_US').parseLoose('4:00:00PM'),
    "Bethlehem",
    "Ramallah",
    "DateTime.now()",
    2,
    "20.00",
    ["Jericho", "Ebediye"],
  );

  List<Ride> transactions = [];

  @override
  Widget build(BuildContext context) {
    transactions = [ride1, ride2];
    return SingleChildScrollView(
      child: Column(
        children: [
          /* RidesList(
            transactions: transactions,
            title: getTranslated(context, "nearyou"),
          ), */
          InfoContainer(
            colors: [
              kAccentDarkColor,
              Color(0xff7be495),
            ],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getTitle(
                    title: getTranslated(context, "ourservices"),
                    color: Colors.white,
                    fontSize: 15),
                getTitle(
                    title: getTranslated(context, "servicedescription"),
                    color: Colors.white)
              ],
            ),
          ),
          InfoContainer(
            colors: [
              kPrimaryColor,
              // kPrimaryColor,
              redColor,
            ],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getTitle(
                    title: getTranslated(context, "homequest2"),
                    color: Colors.white,
                    fontSize: 15),
                CustomElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                        BecomeDriverScreen.routeName,
                        arguments: {"already": already});
                  },
                  title: getTranslated(context, "bcmadriver"),
                  color: redColor,
                  backgroundColor: Colors.white, // Use the component's default.
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
