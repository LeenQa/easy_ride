import 'package:easy_ride/constants.dart';
import 'package:easy_ride/models/ride.dart';
import 'package:flutter/material.dart';

import 'main_drawer.dart';

class RidesList extends StatelessWidget {
  final List<Ride> transactions;
  final String title;
  const RidesList({
    Key key,
    @required this.transactions,
    @required this.title,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
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
                                      color: Colors.blueGrey, fontSize: 12),
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
    );
  }
}
