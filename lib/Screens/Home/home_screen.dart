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
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              //color: kCardColor,
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              //border: Border.all(color: kAccentColor, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            height: MediaQuery.of(context).size.height * 0.32,
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.place,
                        color: Colors.red,
                      ),
                      getTitle(
                          title: "Near You", color: Colors.black, fontSize: 16),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: double.infinity,
                    // margin: EdgeInsets.all(2),
                    height: MediaQuery.of(context).size.height * 0.30,
                    child: transactions.isEmpty
                        ? LayoutBuilder(
                            builder: (ctx, constraints) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text('No rides near you . . .'),
                                ],
                              );
                            },
                          )
                        : ListView.builder(
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
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: kAccentColor,
                                        radius: 30,
                                        child: Padding(
                                          padding: EdgeInsets.all(0),
                                          child: FittedBox(
                                            child: Text(
                                              "${transactions[index].price}₪",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                      title: getTitle(
                                          title:
                                              "From ${transactions[index].startLocation}, To ${transactions[index].arrivalLocation}",
                                          color: Colors.brown[500],
                                          fontSize: 14),
                                      subtitle: Text(
                                        "Number of seats left: ${transactions[index].numOfPassengers}",
                                        style: TextStyle(
                                            color: Colors.blueGrey,
                                            fontSize: 12),
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
                            itemCount: transactions.length,
                          ),
                  ),
                ],
              ),
            ),
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
