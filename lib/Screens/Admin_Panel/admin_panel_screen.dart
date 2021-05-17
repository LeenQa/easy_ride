import 'package:easy_ride/Screens/tabs_screen.dart';
import 'package:easy_ride/components/custom_container.dart';
import 'package:easy_ride/components/custom_elevated_button.dart';
import 'package:easy_ride/components/main_drawer.dart';
import 'package:easy_ride/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:full_screen_image/full_screen_image.dart';

class AdminPanelScreen extends StatefulWidget {
  static const routeName = "/admin_panel";

  @override
  _AdminPanelScreenState createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  @override
  Widget build(BuildContext context) {
    uid = "CjaDPZMqhpQD9j4rs33tqhROVS63";
    return Scaffold(
      appBar: AppBar(
        title: getTitle(
          title: "Admin Panel",
          color: kPrimaryColor,
        ),
        backgroundColor: Colors.white,
      ),
      drawer: MainDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('driver_requests')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return new Text('Loading...');
                  default:
                    return Expanded(
                      child: new ListView(
                        children:
                            snapshot.data.docs.map((DocumentSnapshot document) {
                          return CustomContainer(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // getTitle(
                                //     title: "User: ${document['user']}",
                                //     fontSize: 14),
                                getTitle(
                                    title: "Car Model: ${document['carModel']}",
                                    fontSize: 14),
                                getTitle(
                                    title: "Required Documents:", fontSize: 14),
                                new Container(
                                  height: 150,
                                  margin: const EdgeInsets.all(10),
                                  child: new ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: document['pictures'].length,
                                      itemBuilder: (ctx, index) {
                                        return Container(
                                          margin: EdgeInsets.all(10),
                                          child: new FullScreenWidget(
                                            child: new ClipRRect(
                                              borderRadius:
                                                  new BorderRadius.circular(17),
                                              child: new Image.network(
                                                  document['pictures'][index]),
                                            ),
                                          ),
                                        );
                                      }),
                                  // child: new Text(document['user']),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CustomElevatedButton(
                                      title: "Reject",
                                      backgroundColor: kPrimaryColor,
                                      color: Colors.white,
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection("driver_requests")
                                            .doc(document.id)
                                            .delete()
                                            .whenComplete(
                                                () => print("deleted!"));
                                      },
                                    ),
                                    CustomElevatedButton(
                                      title: "Accept",
                                      backgroundColor: kPrimaryColor,
                                      color: Colors.white,
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('drivers')
                                            .doc(document.id)
                                            .set({
                                          'user': document.id,
                                          'carModel': document['carModel'],
                                          'pictures': document['pictures'],
                                        }).then((value) async {
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(document.id)
                                              .update({
                                            'isDriver': true,
                                          });
                                          await FirebaseFirestore.instance
                                              .collection("driver_requests")
                                              .doc(document.id)
                                              .delete()
                                              .whenComplete(
                                                  () => print("deleted!"));
                                        });
                                      },
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    );
                }
              }),
        ],
      ),
    );
  }
}
