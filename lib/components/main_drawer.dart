import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/Screens/Become_Driver/become_driver_screen.dart';
import 'package:easy_ride/Screens/Offer_Ride/offer_ride_screen.dart';
import 'package:easy_ride/Screens/Profile/profile_screen.dart';
import 'package:easy_ride/Screens/Settings/settings_screen.dart';
import 'package:easy_ride/Screens/User_Search/user_search_screen.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import '../constants.dart';
import '../main.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

Widget getTitle({String title, Color color, double fontSize}) {
  if (color == null) {
    color = Colors.black54;
  }
  if (fontSize == null) {
    fontSize = 17;
  }
  return Text(title,
      style: TextStyle(
        color: color,
        fontFamily: 'Quicksand',
        fontWeight: FontWeight.w600,
        fontSize: fontSize,
      ));
}

class _MainDrawerState extends State<MainDrawer> {
  Locale locale;
  void _changeLanguage(Language language) async {
    Locale _locale = await setLocale(language.languageCode);
    MyApp.setLocale(context, _locale);
  }

  bool langValue;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getLocale().then((locale) {
      if (locale.languageCode.contains('en')) {
        langValue = true;
      }
      langValue = false;
    });
  }

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
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  String uid;
  getUser() {
    final User user = auth.currentUser;
    uid = user.uid;
  }

  @override
  Widget build(BuildContext context) {
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
                  StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .snapshots(),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListTile(
                          leading: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 26,
                          ),
                          title: getTitle(
                            title:
                                "${snapshot.data.data()['firstName']} ${snapshot.data.data()['lastName']}",
                            color: Colors.white,
                            /* style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Quicksand',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ), */
                          ),
                        );
                      }),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          buildListTile(
            context,
            Icons.person_pin_rounded,
            () {
              Navigator.of(context).pushNamed(ProfileScreen.routeName);
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
              Navigator.of(context).pushNamed(UserSearchScreen.routeName);
            },
            getTitle(title: getTranslated(context, 'srchforausr')),
          ),
          buildListTile(
            context,
            Icons.add_circle_outline_outlined,
            () {
              Navigator.of(context).pushNamed(OfferRideScreen.routeName);
            },
            getTitle(title: getTranslated(context, 'offrard')),
          ),
          buildListTile(
            context,
            Icons.check_circle_outline_outlined,
            () {
              Navigator.of(context).pushNamed(BecomeDriverScreen.routeName);
            },
            getTitle(title: getTranslated(context, 'bcmadriver')),
          ),
          Divider(
            thickness: 1,
          ),
          buildListTile(context, Icons.settings, () {
            Navigator.of(context).pushNamed(SettingsScreen.routeName);
          }, getTitle(title: getTranslated(context, 'settings'))),
          Divider(
            thickness: 1,
          ),
          buildListTile(
            context,
            Icons.language,
            () {},
            DropdownButton<Language>(
              underline: SizedBox(),
              hint: Text(getTranslated(context, "switchlang")),
              onChanged: (Language language) {
                _changeLanguage(language);
              },
              items: Language.languageList()
                  .map<DropdownMenuItem<Language>>(
                    (e) => DropdownMenuItem<Language>(
                      value: e,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            e.flag,
                            style: TextStyle(fontSize: 30),
                          ),
                          Text(e.name)
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          Divider(
            thickness: 1,
          ),
          buildListTile(context, Icons.logout, () {
            FirebaseAuth.instance.signOut();
          }, getTitle(title: getTranslated(context, 'logout'))),
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          //   child: LiteRollingSwitch(
          //     value: true,
          //     textOn: "English",
          //     textOff: "        العربية",
          //     colorOn: Colors.lightBlue,
          //     colorOff: Colors.pink[200],
          //     iconOn: Icons.language,
          //     iconOff: Icons.language,
          //     textSize: 17,
          //     onChanged: (bool position) {
          //       // print(locale.languageCode);
          //       if (position) {
          //         _changeLanguage(Language.languageList().elementAt(0));
          //       } else {
          //         _changeLanguage(Language.languageList().elementAt(1));
          //       }
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}

class Language {
  final int id;
  final String flag;
  final String name;
  final String languageCode;

  Language(this.id, this.flag, this.name, this.languageCode);

  static List<Language> languageList() {
    return <Language>[
      Language(1, "", "English", "en"),
      Language(2, "", "اَلْعَرَبِيَّةُ‎", "ar"),
    ];
  }
}
