import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/Screens/Become_Driver/become_driver_screen.dart';
import 'package:easy_ride/components/custom_elevated_button.dart';
import 'package:easy_ride/components/info_container.dart';
import 'package:easy_ride/constants.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          InfoContainer(
            colors: [
              redColor,
              redColorLight,
            ],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getTitle(
                  title: getTranslated(context, "aboutus"),
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                getTitle(
                  title: getTranslated(context, "servicedescription"),
                  color: Colors.white,
                )
              ],
            ),
          ),
          InfoContainer(
            colors: [
              redColor,
              kprimaryLitColor,
            ],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getTitle(
                    title: getTranslated(context, "ourservices"),
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
                SizedBox(
                  height: 14,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Icon(
                          Icons.search,
                          size: 20,
                          color: Colors.white,
                        ),
                        getTitle(
                            title: getTranslated(context, "srchforard"),
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w800)
                      ],
                    ),
                    Column(
                      children: [
                        Icon(
                          Icons.local_offer,
                          size: 20,
                          color: Colors.white,
                        ),
                        getTitle(
                            title: getTranslated(context, "offrard"),
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w800)
                      ],
                    ),
                    Column(
                      children: [
                        Icon(
                          Icons.drive_eta,
                          size: 20,
                          color: Colors.white,
                        ),
                        getTitle(
                            title: getTranslated(context, "bcmadriver"),
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w800)
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 14,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Icon(
                          Icons.chat_bubble,
                          size: 20,
                          color: Colors.white,
                        ),
                        getTitle(
                            title: getTranslated(context, "messaging"),
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w800)
                      ],
                    ),
                    Column(
                      children: [
                        Icon(
                          Icons.rate_review,
                          size: 20,
                          color: Colors.white,
                        ),
                        getTitle(
                            title: getTranslated(context, "reviewing"),
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w800)
                      ],
                    ),
                    Column(
                      children: [
                        Icon(
                          Icons.map,
                          size: 20,
                          color: Colors.white,
                        ),
                        getTitle(
                            title: getTranslated(context, "maps"),
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w800),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 14,
                ),
              ],
            ),
          ),
          InfoContainer(
            colors: [
              kPrimaryColor,
              kprimaryLitColor,
            ],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getTitle(
                    title: getTranslated(context, "homequest2"),
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
                CustomElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                        BecomeDriverScreen.routeName,
                        arguments: {"already": already});
                  },
                  title: getTranslated(context, "bcmadriver"),
                  color: kPrimaryDarkColor,
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
