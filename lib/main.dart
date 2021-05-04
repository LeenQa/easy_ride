import 'package:easy_ride/Screens/Admin_Panel/admin_panel_screen.dart';
import 'package:easy_ride/Screens/Become_Driver/become_driver_screen.dart';
import 'package:easy_ride/Screens/Login/login_screen.dart';
import 'package:easy_ride/Screens/Offer_Ride/offer_ride_screen.dart';
import 'package:easy_ride/Screens/Profile/profile_screen.dart';
import 'package:easy_ride/Screens/Search/search_screen.dart';
import 'package:easy_ride/Screens/Settings/settings_screen.dart';
import 'package:easy_ride/Screens/User_Search/user_search_screen.dart';
import 'package:easy_ride/Screens/tabs_screen.dart';
import 'package:easy_ride/models/driver.dart';
import 'package:easy_ride/models/request.dart';
import 'package:easy_ride/models/ride.dart';
import 'package:easy_ride/models/user.dart' as User;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:easy_ride/Screens/Welcome/welcome_screen.dart';
import 'package:easy_ride/constants.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'Screens/Driver_Rides/driver_rides.dart';
import 'Screens/Edit_Profile_Screen/edit_profile_screen.dart';
import 'Screens/Map/map_screen.dart';
import 'Screens/Rides_List/rides_list.dart';
import 'Screens/Signup/signup_screen.dart';
import 'localization/demo_localization.dart';
import 'localization/language_constants.dart';
import 'package:provider/provider.dart';
import 'models/address.dart';
import 'models/searched_ride.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // static getLocalNotificationsPlugin() {
  //   return flutterLocalNotificationsPlugin;
  // }

  // static getchannel() {
  //   return channel;
  // }

  @override
  _MyAppState createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale _locale;
  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Driver>(
          create: (_) => Driver(),
        ),
        ChangeNotifierProvider<Request>(
          create: (_) => Request(),
        ),
        ChangeNotifierProvider<Ride>(
          create: (_) => Ride(),
        ),
        ChangeNotifierProvider<User.User>(
          create: (_) => User.User(),
        ),
        ChangeNotifierProvider<Address>(
          create: (_) => Address(),
        ),
        ChangeNotifierProvider<SearchedRide>(
          create: (_) => SearchedRide(),
        )
      ],
      child: MaterialApp(
        locale: _locale,
        supportedLocales: [
          Locale('en', 'US'),
          Locale('ar', 'AR'),
        ],
        localizationsDelegates: [
          DemoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (deviceLocale, supportedLocales) {
          for (var locale in supportedLocales) {
            if (locale.languageCode == deviceLocale.languageCode) {
              return deviceLocale;
            }
          }
          return supportedLocales.first;
        },
        debugShowCheckedModeBanner: false,
        title: 'Flutter Auth',
        theme: ThemeData(
          fontFamily: 'Quicksand',
          primaryColor: kPrimaryColor,
          accentColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                headline5: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.lightBlue,
                ),
                button: TextStyle(color: Colors.blue),
              ),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapchot) {
            if (userSnapchot.hasData) {
              if (FirebaseAuth.instance.currentUser.uid ==
                  "fjsrQq4AmdVWHK8Z7vSHlFRelBV2") {
                return AdminPanelScreen();
              } else
                return TabsScreen();
            } else
              return LoginScreen();
          },
        ),
        routes: {
          //'/': (ctx) => WelcomeScreen(),
          SignUpScreen.routeName: (ctx) => SignUpScreen(),
          LoginScreen.routeName: (ctx) => LoginScreen(),
          TabsScreen.routeName: (ctx) => TabsScreen(),
          ProfileScreen.routeName: (ctx) => ProfileScreen(),
          UserSearchScreen.routeName: (ctx) => UserSearchScreen(),
          OfferRideScreen.routeName: (ctx) => OfferRideScreen(),
          BecomeDriverScreen.routeName: (ctx) => BecomeDriverScreen(),
          SettingsScreen.routeName: (ctx) => SettingsScreen(),
          AdminPanelScreen.routeName: (ctx) => AdminPanelScreen(),
          ProfilePicScreen.routeName: (ctx) => ProfilePicScreen(),
          MapScreen.routeName: (ctx) => MapScreen(),
          RidesList.routeName: (ctx) => RidesList(),
          DriverRides.routeName: (ctx) => DriverRides(),
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(builder: (ctx) {
            var returnedScreen = StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (ctx, userSnapchot) {
                if (userSnapchot.hasData) {
                  return TabsScreen();
                } else
                  return LoginScreen();
              },
            );
            return returnedScreen;
          });
        },
      ),
    );
  }
}
