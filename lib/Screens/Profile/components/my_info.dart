import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/components/main_drawer.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:easy_ride/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../constants.dart';

class MyInfo extends StatelessWidget {
  final String id;
  double sizedBoxSize = 10;
  final bool isDriver;
  //if not driver change it to 20

  final ifDriverS = 20;

  MyInfo(this.id, this.isDriver);

  //final Size size = Size.fromWidth(120);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection("users").doc(id).snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center();
            default:
              if (snapshot.hasError) {
                print(snapshot.error);
                return getTitle(title: getTranslated(context, "sthwrong"));
              } else
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 3,
                              color: kPrimaryColor,
                            ),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(
                                  snapshot.data.data()["urlAvatar"]),
                              fit: BoxFit.fitWidth,
                            )),
                      ),
                      SizedBox(
                        height: sizedBoxSize,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          getTitle(
                              title:
                                  "${snapshot.data.data()["firstName"]} ${snapshot.data.data()["lastName"]}",
                              fontSize: 18),
                        ],
                      ),
                      //if driver display this
                      SizedBox(
                        height: 10,
                      ),
                      isDriver
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.verified_rounded,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: getTitle(
                                      title: getTranslated(
                                          context, 'verifieddriver'),
                                      color: Colors.blue[400]),
                                )
                              ],
                            )
                          : Container()
                    ],
                  ),
                );
          }
        });
  }
}
