import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/Screens/Profile/profile_screen.dart';
import 'package:easy_ride/components/custom_container.dart';
import 'package:easy_ride/components/main_drawer.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';

class UserReportsScreen extends StatelessWidget {
  static const routeName = "/user_reports";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: getTitle(
          title: getTranslated(context, "userreports"),
          color: kPrimaryColor,
        ),
        backgroundColor: Colors.white,
      ),
      drawer: MainDrawer(),
      body: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(5),
        child: StreamBuilder<QuerySnapshot>(
            stream:
                FirebaseFirestore.instance.collection('reports').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot1) {
              if (snapshot1.hasError)
                return getTitle(
                    title:
                        '${getTranslated(context, "error")}: ${snapshot1.error}');
              switch (snapshot1.connectionState) {
                case ConnectionState.waiting:
                  return getTitle(
                      title: '${getTranslated(context, "loading")}...');
                default:
                  return ListView.builder(
                    itemCount: snapshot1.data.docs.length,
                    itemBuilder: (ctx, index) {
                      return CustomContainer(
                        boxShadowColor: kPrimaryLightColor,
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                                child: getTitle(
                                    title:
                                        getTranslated(context, "reporteduser"),
                                    fontSize: 16)),
                            Card(
                              elevation: 0,
                              child: FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(snapshot1.data.docs[index]
                                        .data()["reportedId"])
                                    .get(),
                                builder: (BuildContext context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                      return Center(
                                          child: CircularProgressIndicator());
                                    default:
                                      if (snapshot.hasError) {
                                        print(snapshot.error);
                                        return getTitle(
                                            title: getTranslated(
                                                context, "sthwrong"));
                                      } else {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                                ProfileScreen.routeName,
                                                arguments: {
                                                  'id': snapshot1
                                                      .data.docs[index]
                                                      .data()["reportedId"],
                                                  'name':
                                                      "${snapshot.data.data()["firstName"]} ${snapshot.data.data()["lastName"]}",
                                                  'urlAvatar': snapshot.data
                                                      .data()["urlAvatar"],
                                                  'isMe': false,
                                                  'isDriver': snapshot.data
                                                      .data()["isDriver"]
                                                });
                                          },
                                          child: getTitle(
                                              title:
                                                  "${getTranslated(context, "name")}: ${snapshot.data.data()["firstName"]} ${snapshot.data.data()["lastName"]} \n${getTranslated(context, "email")}: ${snapshot.data.data()["email"]}",
                                              fontSize: 14,
                                              decoration:
                                                  TextDecoration.underline),
                                        );
                                      }
                                  }
                                },
                              ),
                            ),
                            Card(
                                elevation: 0,
                                child: getTitle(
                                    title:
                                        "${getTranslated(context, "reasonforreport")}: ${snapshot1.data.docs[index].data()["report"]}",
                                    fontSize: 14)),
                            Card(
                              elevation: 0,
                              child: FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(snapshot1.data.docs[index]
                                        .data()["reporterId"])
                                    .get(),
                                builder: (BuildContext context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                      return Center(
                                          child: CircularProgressIndicator());
                                    default:
                                      if (snapshot.hasError) {
                                        print(snapshot.error);
                                        return getTitle(
                                            title: getTranslated(
                                                context, "sthwrong"));
                                      } else {
                                        return getTitle(
                                            title:
                                                "${getTranslated(context, "reporter")}: ${snapshot.data.data()["firstName"]} ${snapshot.data.data()["lastName"]}",
                                            fontSize: 13);
                                      }
                                  }
                                },
                              ),
                            ),
                            Center(
                              child: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection("reports")
                                      .doc(snapshot1.data.docs[index].id)
                                      .delete();
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
              }
            }),
      ),
    );
  }
}
