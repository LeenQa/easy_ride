import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/Screens/Become_Driver/become_driver_screen.dart';
import 'package:easy_ride/Screens/Driver_Rides/driver_rides.dart';
import 'package:easy_ride/Screens/Login/login_screen.dart';
import 'package:easy_ride/Screens/Offer_Ride/offer_ride_screen.dart';
import 'package:easy_ride/Screens/Profile/profile_screen.dart';
import 'package:easy_ride/Screens/Settings/settings_screen.dart';
import 'package:easy_ride/Screens/User_Search/user_search_screen.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:easy_ride/models/ride.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

Widget getTitle(
    {String title,
    Color color,
    double fontSize,
    TextDecoration decoration,
    Color decorationColor}) {
  if (color == null) {
    color = Colors.black54;
  }
  if (fontSize == null) {
    fontSize = 17;
  }

  if (decoration == null) {
    decoration = TextDecoration.none;
  }
  return Text(title,
      style: TextStyle(
          color: color,
          fontFamily: 'Quicksand',
          fontWeight: FontWeight.w600,
          fontSize: fontSize,
          decoration: decoration,
          decorationColor: Colors.blueGrey));
}

class _MainDrawerState extends State<MainDrawer> {
  // Locale locale;
  // void _changeLanguage(Language language) async {
  //   Locale _locale = await setLocale(language.languageCode);
  //   MyApp.setLocale(context, _locale);
  // }

  // bool langValue;
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   getLocale().then((locale) {
  //     if (locale.languageCode.contains('en')) {
  //       langValue = true;
  //     }
  //     langValue = false;
  //   });
  // }

  Widget buildListTile(
      BuildContext context, IconData icon, Function tabHandler, Widget title) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).primaryColor,
        size: 26,
      ),
      title: title,
      onTap: tabHandler,
    );
  }

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
    if (data != null) {
      already = true;
      print("true");
    } else {
      already = false;
      print("false");
    }
  }

  Future<void> _showDriverRides(BuildContext ctx) async {
    List<Ride> driverRides = [];
    await FirebaseFirestore.instance
        .collection("rides")
        .doc(uid)
        .collection("userrides")
        .orderBy('date', descending: true)
        .get()
        .then((querySnapshot) async {
      querySnapshot.docs.forEach((result) {
        String startTime = result.data()['startTime'];
        String startLocation = result.data()['startLocation'];
        String arrivalLocation = result.data()['arrivalLocation'];
        String date = result.data()['date'];
        int numOfPassengers = result.data()['numOfPassengers'];
        String price = result.data()['price'];
        List stopovers = result.data()['stopovers'];
        String driver = result.data()['driver'];
        String description = result.data()['description'];
        String id = result.id;
        driverRides.add(new Ride(
            startTime,
            startLocation,
            arrivalLocation,
            date,
            numOfPassengers,
            price,
            stopovers,
            driver,
            description,
            [],
            id));
      });
    });
    showCupertinoModalPopup(
      context: ctx,
      builder: (_) {
        return DriverRides(
          driverRides: driverRides,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream:
            FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Drawer(
            child: Column(
              children: [
                Container(
                  height: 80,
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.centerLeft,
                  color: Theme.of(context).primaryColor,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 26,
                          ),
                          title: getTitle(
                            title:
                                "${snapshot.data.data()['firstName']} ${snapshot.data.data()['lastName']}",
                            color: Colors.white,
                          ),
                        ),
                        //streambuilder
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                if (uid != "fjsrQq4AmdVWHK8Z7vSHlFRelBV2")
                  Column(
                    children: [
                      buildListTile(
                        context,
                        Icons.person_pin_rounded,
                        () {
                          Navigator.of(context)
                              .pushNamed(ProfileScreen.routeName, arguments: {
                            'name':
                                "${snapshot.data.data()['firstName']} ${snapshot.data.data()['lastName']}",
                            'urlAvatar': "${snapshot.data.data()['urlAvatar']}",
                            'isMe': true,
                          });
                        },
                        getTitle(title: getTranslated(context, 'profile')),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      buildListTile(
                        context,
                        Icons.person_search_outlined,
                        () {
                          Navigator.of(context)
                              .pushNamed(UserSearchScreen.routeName);
                        },
                        getTitle(title: getTranslated(context, 'srchforausr')),
                      ),
                      buildListTile(
                        context,
                        Icons.add_circle_outline_outlined,
                        () {
                          Navigator.of(context)
                              .pushNamed(OfferRideScreen.routeName);
                        },
                        getTitle(title: getTranslated(context, 'offrard')),
                      ),
                      buildListTile(
                        context,
                        Icons.check_circle_outline_outlined,
                        () {
                          Navigator.of(context).pushNamed(
                              BecomeDriverScreen.routeName,
                              arguments: {"already": already});
                        },
                        getTitle(title: getTranslated(context, 'bcmadriver')),
                      ),
                      buildListTile(
                        context,
                        Icons.add_circle_outline_outlined,
                        () => _showDriverRides(context),
                        getTitle(title: "My Rides"),
                      ),
                      Divider(
                        thickness: 1,
                      ),
                      buildListTile(context, Icons.settings, () {
                        Navigator.of(context)
                            .pushNamed(SettingsScreen.routeName);
                      }, getTitle(title: getTranslated(context, 'settings'))),
                      Divider(
                        thickness: 1,
                      ),
                    ],
                  ),
                // buildListTile(
                //   context,
                //   Icons.language,
                //   () {},
                //   DropdownButton<Language>(
                //     underline: SizedBox(),
                //     hint: Text(getTranslated(context, "switchlang")),
                //     onChanged: (Language language) {
                //       _changeLanguage(language);
                //     },
                //     items: Language.languageList()
                //         .map<DropdownMenuItem<Language>>(
                //           (e) => DropdownMenuItem<Language>(
                //             value: e,
                //             child: Row(
                //               mainAxisAlignment: MainAxisAlignment.spaceAround,
                //               children: <Widget>[
                //                 Text(
                //                   e.flag,
                //                   style: TextStyle(fontSize: 30),
                //                 ),
                //                 Text(e.name)
                //               ],
                //             ),
                //           ),
                //         )
                //         .toList(),
                //   ),
                // ),
                // Divider(
                //   thickness: 1,
                // ),
                buildListTile(context, Icons.logout, () {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushNamed(LoginScreen.routeName);
                }, getTitle(title: getTranslated(context, 'logout'))),
              ],
            ),
          );
        });
  }
}
