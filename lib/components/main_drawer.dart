import 'package:easy_ride/Screens/Become_Driver/become_driver_screen.dart';
import 'package:easy_ride/Screens/Offer_Ride/offer_ride_screen.dart';
import 'package:easy_ride/Screens/Profile/profile_screen.dart';
import 'package:easy_ride/Screens/Settings/settings_screen.dart';
import 'package:easy_ride/Screens/User_Search/user_search_screen.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import '../constants.dart';
import '../main.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
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
      BuildContext context, String title, IconData icon, Function tabHandler) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).primaryColor,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontFamily: 'Quicksand',
          fontWeight: FontWeight.w700,
          fontSize: 17,
        ),
      ),
      onTap: tabHandler,
    );
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
            child: ListTile(
              leading: Icon(
                Icons.person,
                color: Colors.white,
                size: 26,
              ),
              title: Text(
                'username',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          buildListTile(
            context,
            getTranslated(context, 'profile'),
            Icons.person_pin_rounded,
            () {
              Navigator.of(context).pushNamed(ProfileScreen.routeName);
            },
          ),
          Divider(
            thickness: 3,
          ),
          buildListTile(
            context,
            getTranslated(context, 'srchforausr'),
            Icons.person_search_outlined,
            () {
              Navigator.of(context).pushNamed(UserSearchScreen.routeName);
            },
          ),
          buildListTile(
            context,
            getTranslated(context, 'offrard'),
            Icons.add_circle_outline_outlined,
            () {
              Navigator.of(context).pushNamed(OfferRideScreen.routeName);
            },
          ),
          buildListTile(
            context,
            getTranslated(context, 'bcmadriver'),
            Icons.check_circle_outline_outlined,
            () {
              Navigator.of(context).pushNamed(BecomeDriverScreen.routeName);
            },
          ),
          Divider(
            thickness: 3,
          ),
          buildListTile(
            context,
            getTranslated(context, 'settings'),
            Icons.settings,
            () {
              Navigator.of(context).pushNamed(SettingsScreen.routeName);
            },
          ),
          Divider(
            thickness: 3,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: LiteRollingSwitch(
              value: true,
              textOn: "English",
              textOff: "        العربية",
              colorOn: Colors.lightBlue,
              colorOff: Colors.pink[200],
              iconOn: Icons.language,
              iconOff: Icons.language,
              textSize: 17,
              onChanged: (bool position) {
                // print(locale.languageCode);
                if (position) {
                  _changeLanguage(Language.languageList().elementAt(0));
                } else {
                  _changeLanguage(Language.languageList().elementAt(1));
                }
              },
            ),
          ),
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
      Language(1, "🇺🇸", "English", "en"),
      Language(2, "🇸🇦", "اَلْعَرَبِيَّةُ‎", "ar"),
    ];
  }
}
