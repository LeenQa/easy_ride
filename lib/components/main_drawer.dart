import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/Screens/Admin_Panel/admin_panel_screen.dart';
import 'package:easy_ride/Screens/Become_Driver/become_driver_screen.dart';
import 'package:easy_ride/Screens/Driver_Rides/driver_rides.dart';
import 'package:easy_ride/Screens/Login/login_screen.dart';
import 'package:easy_ride/Screens/Offer_Ride/offer_ride_screen.dart';
import 'package:easy_ride/Screens/Profile/profile_screen.dart';
import 'package:easy_ride/Screens/Settings/settings_screen.dart';
import 'package:easy_ride/Screens/User_Reports/user_reports.dart';
import 'package:easy_ride/Screens/User_Rides/user_rides_screen.dart';
import 'package:easy_ride/Screens/User_Search/user_search_screen.dart';
import 'package:easy_ride/Screens/tabs_screen.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:easy_ride/models/user.dart' as UserModel;
import 'package:easy_ride/models/ride.dart';
import 'package:easy_ride/models/searched_ride.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

Widget getTitle(
    {String title,
    Color color,
    double fontSize,
    TextDecoration decoration,
    FontWeight fontWeight,
    Color decorationColor}) {
  if (color == null) {
    color = Colors.black54;
  }
  if (fontSize == null) {
    fontSize = 14;
  }

  if (decoration == null) {
    decoration = TextDecoration.none;
  }
  return Text(title,
      style: TextStyle(
          color: color,
          fontFamily: 'Quicksand',
          fontWeight: fontWeight == null ? FontWeight.w600 : fontWeight,
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
    if (data.exists) {
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

  Future<void> _showUserRides(BuildContext ctx) async {
    List<Ride> userRidesDetails = [];
    List<SearchedRide> userRides = [];
    List<UserModel.User> drivers = [];
    await FirebaseFirestore.instance
        .collection("requests")
        .orderBy('date', descending: true)
        .get()
        .then((querySnapshot) async {
      querySnapshot.docs.forEach((result) async {
        if (result.data()['user'] == uid) {
          int numOfPassengers = result.data()['numOfPassengers'];
          String status = result.data()['status'];
          String ride = result.data()['ride'];
          String meetingPoint = result.data()['startLocation'];
          String request = result.id;
          String requestDate = result.data()['date'];
          bool isReviewed = result.data()['isReviewed'];

          await FirebaseFirestore.instance
              .collection("users")
              .get()
              .then((querySnapshot) {
            querySnapshot.docs.forEach((result) async {
              await FirebaseFirestore.instance
                  .collection("rides")
                  .doc(result.id)
                  .collection("userrides")
                  .doc(ride)
                  .get()
                  .then((value) async {
                if (value.exists) {
                  String startTime = value.data()['startTime'];
                  String startLocation = value.data()['startLocation'];
                  String arrivalLocation = value.data()['arrivalLocation'];
                  String date = value.data()['date'];
                  int numOfRidePassengers = value.data()['numOfPassengers'];
                  String price = value.data()['price'];
                  List stopovers = value.data()['stopovers'];
                  String driverid = value.data()['driver'];
                  String description = value.data()['description'];

                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(driverid)
                      .get()
                      .then((value) {
                    UserModel.User driver = new UserModel.User();
                    driver.firstName = value.data()["firstName"];
                    driver.lastName = value.data()["lastName"];
                    driver.urlAvatar = value.data()["urlAvatar"];
                    driver.isDriver = value.data()["isDriver"];

                    drivers.add(driver);

                    userRidesDetails.add(new Ride(
                        startTime,
                        startLocation,
                        arrivalLocation,
                        date,
                        numOfRidePassengers,
                        price,
                        stopovers,
                        driverid,
                        description));

                    userRides.add(new SearchedRide(
                      numOfPassengers: numOfPassengers,
                      ride: ride,
                      status: status,
                      request: request,
                      pickUpLocation: meetingPoint,
                      date: requestDate,
                      isReviewed: isReviewed,
                    ));
                  });
                }
              });
            });
          });
        }
      });
    }).then((_) {
      Future.delayed(const Duration(milliseconds: 1500)).then((_) {
        showCupertinoModalPopup(
          context: ctx,
          builder: (_) {
            return UserRides(
              userRidesDetails: userRidesDetails,
              userRides: userRides,
              drivers: drivers,
            );
          },
        );
      });
    });
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
                  height: 85,
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  color: Theme.of(context).primaryColor,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            foregroundImage:
                                NetworkImage(snapshot.data.data()['urlAvatar']),
                            backgroundColor: Colors.transparent,
                          ),
                          title: getTitle(
                              title:
                                  "${snapshot.data.data()['firstName']} ${snapshot.data.data()['lastName']}",
                              color: Colors.white,
                              fontSize: 17),
                        ),
                        //streambuilder
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                uid != "CjaDPZMqhpQD9j4rs33tqhROVS63"
                    ? Column(
                        children: [
                          buildListTile(
                            context,
                            Icons.person_pin_rounded,
                            () async {
                              var driver = await FirebaseFirestore.instance
                                  .collection("drivers")
                                  .doc(uid)
                                  .get();
                              Navigator.of(context).pushNamed(
                                  ProfileScreen.routeName,
                                  arguments: {
                                    'id': uid,
                                    'name':
                                        "${snapshot.data.data()['firstName']} ${snapshot.data.data()['lastName']}",
                                    'urlAvatar':
                                        "${snapshot.data.data()['urlAvatar']}",
                                    'isMe': true,
                                    'isDriver': driver.exists,
                                  });
                            },
                            getTitle(
                                title: getTranslated(context, 'profile'),
                                fontSize: 16),
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
                            getTitle(
                                title: getTranslated(context, 'srchforausr'),
                                fontSize: 16),
                          ),
                          buildListTile(
                            context,
                            Icons.arrow_forward,
                            () => _showUserRides(context),
                            getTitle(
                                title: getTranslated(context, "requestedrides"),
                                fontSize: 16),
                          ),
                          isDriver
                              ? Column(
                                  children: [
                                    buildListTile(
                                      context,
                                      Icons.add_circle_outline_outlined,
                                      () {
                                        Navigator.of(context).pushNamed(
                                            OfferRideScreen.routeName);
                                      },
                                      getTitle(
                                          title:
                                              getTranslated(context, 'offrard'),
                                          fontSize: 16),
                                    ),
                                    buildListTile(
                                      context,
                                      Icons.list_rounded,
                                      () => _showDriverRides(context),
                                      getTitle(
                                          title: getTranslated(
                                              context, "offeredrides"),
                                          fontSize: 16),
                                    ),
                                  ],
                                )
                              : buildListTile(
                                  context,
                                  Icons.check_circle_outline_outlined,
                                  () {
                                    Navigator.of(context).pushNamed(
                                        BecomeDriverScreen.routeName,
                                        arguments: {"already": already});
                                  },
                                  getTitle(
                                      title:
                                          getTranslated(context, 'bcmadriver'),
                                      fontSize: 16),
                                ),
                          Divider(
                            thickness: 1,
                          ),
                          buildListTile(
                            context,
                            Icons.settings,
                            () {
                              Navigator.of(context)
                                  .pushNamed(SettingsScreen.routeName);
                            },
                            getTitle(
                                title: getTranslated(context, 'settings'),
                                fontSize: 16),
                          ),
                          Divider(
                            thickness: 1,
                          ),
                          buildListTile(context, Icons.logout, () async {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(uid)
                                .update({'token': ''});
                            FirebaseAuth.instance.signOut();
                            Navigator.of(context)
                                .pushNamed(LoginScreen.routeName);
                          },
                              getTitle(
                                  title: getTranslated(context, 'logout'),
                                  fontSize: 16)),
                        ],
                      )
                    // buildListTile(
                    //   context,
                    //   Icons.language,
                    //   () {},
                    //   DropdownButton<Language>(
                    //     underline: SizedBox(),
                    //     hint: getTitle(title:getTranslated(context, "switchlang")),
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
                    //                 getTitle(title:
                    //                   e.flag,
                    //                   style: TextStyle(fontSize: 30),
                    //                 ),
                    //                 getTitle(title:e.name)
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
                    : Column(
                        children: [
                          buildListTile(context, Icons.admin_panel_settings,
                              () {
                            Navigator.of(context)
                                .pushNamed(AdminPanelScreen.routeName);
                          },
                              getTitle(
                                  title: getTranslated(context, "adminpanel"),
                                  fontSize: 16)),
                          buildListTile(context, Icons.report, () {
                            Navigator.of(context)
                                .pushNamed(UserReportsScreen.routeName);
                          },
                              getTitle(
                                  title: getTranslated(context, "userreports"),
                                  fontSize: 16)),
                          buildListTile(context, Icons.logout, () async {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(uid)
                                .update({'token': ''});
                            FirebaseAuth.instance.signOut();
                            Navigator.of(context)
                                .pushNamed(LoginScreen.routeName);
                          },
                              getTitle(
                                  title: getTranslated(context, 'logout'),
                                  fontSize: 16)),
                        ],
                      ),
              ],
            ),
          );
        });
  }
}
