import 'package:easy_ride/components/rides_list.dart';
import 'package:easy_ride/constants.dart';
import 'package:easy_ride/models/ride.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../components/main_drawer.dart';

class HomeScreen extends StatelessWidget {
  DateTime dateTime = DateFormat('h:mm:ssa', 'en_US').parseLoose('2:00:00AM');
  Ride ride1 = new Ride(
    DateFormat('h:mm:ssa', 'en_US').parseLoose('2:00:00PM'),
    DateFormat('h:mm:ssa', 'en_US').parseLoose('4:00:00PM'),
    "Bethlehem",
    "Ramallah",
    DateTime.now(),
    2,
    20.00,
    ["Jericho", "Ebediye"],
  );
  Ride ride2 = new Ride(
    DateFormat('h:mm:ssa', 'en_US').parseLoose('2:00:00PM'),
    DateFormat('h:mm:ssa', 'en_US').parseLoose('4:00:00PM'),
    "Bethlehem",
    "Ramallah",
    DateTime.now(),
    2,
    20.00,
    ["Jericho", "Ebediye"],
  );
  List<Ride> transactions = [];
  @override
  Widget build(BuildContext context) {
    transactions = [ride1, ride2];
    return SingleChildScrollView(
      child: Column(
        children: [
          RidesList(
            transactions: transactions,
            title: "Near You",
          ),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.18,
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 21),
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 5.0,
                  color: Colors.grey[300],
                  spreadRadius: 5.0,
                ),
              ],
              borderRadius: BorderRadius.circular(8),
              color: kPrimaryColor,
              gradient: LinearGradient(
                colors: [
                  kAccentDarkColor,
                  //Color(0xffff5d6e),
                  Color(0xff7be495),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getTitle(
                    title: "Do you want to offer other people Rides?",
                    color: Colors.white,
                    fontSize: 15),
                ElevatedButton(
                  onPressed: () {},
                  child: getTitle(
                      title: "Become a Driver",
                      color: kAccentDarkColor,
                      fontSize: 14),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    )),
                    elevation: MaterialStateProperty.resolveWith<double>(
                        (Set<MaterialState> states) {
                      return 5; // Use the component's default.
                    }),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.green;
                        else
                          return Colors.white; // Use the component's default.
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.18,
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            margin: EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 5.0,
                  color: Colors.grey[300],
                  spreadRadius: 5.0,
                ),
              ],
              borderRadius: BorderRadius.circular(8),
              color: kPrimaryColor,
              gradient: LinearGradient(
                colors: [
                  kPrimaryColor,
                  // kPrimaryColor,
                  Color(0xffff5d6e),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getTitle(
                    title: "Do you want to offer other people Rides?",
                    color: Colors.white,
                    fontSize: 15),
                ElevatedButton(
                  onPressed: () {},
                  child: getTitle(
                      title: "Become a Driver",
                      color: kPrimaryDarkColor,
                      fontSize: 14),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    )),
                    elevation: MaterialStateProperty.resolveWith<double>(
                        (Set<MaterialState> states) {
                      return 5; // Use the component's default.
                    }),
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.green;
                        else
                          return Colors.white; // Use the component's default.
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
