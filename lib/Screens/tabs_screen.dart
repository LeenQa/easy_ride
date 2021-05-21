import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easy_ride/Screens/Home/home_screen.dart';
import 'package:easy_ride/Screens/Messages/messages_screen.dart';
import 'package:easy_ride/Screens/Search/search_screen.dart';
import 'package:easy_ride/components/main_drawer.dart';
import 'package:easy_ride/constants.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/tabs';
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

bool isDriver = false;
String uid = "";

class _TabsScreenState extends State<TabsScreen> {
  @override
  void initState() {
    super.initState();
    getUser();
    isDriverMethod(uid);
    getToken();
  }

  getToken() async {
    var status = await OneSignal.shared.getDeviceState();
    String tokenId = status.userId;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'token': tokenId});
  }

  isDriverMethod(String uid) async {
    await FirebaseFirestore.instance
        .collection('drivers')
        .doc(uid)
        .get()
        .then((value) {
      if (value.exists) {
        isDriver = true;
      } else {
        isDriver = false;
      }
    });
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  bool already;
  getUser() {
    final User user = auth.currentUser;
    uid = user.uid;
  }

  int _selectedPageIndex = 0;

  void selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, Object>> _pages = [
      {'page': HomeScreen(), 'title': 'EasyRide'},
      {'page': MessagesScreen(), 'title': getTranslated(context, 'messages')},
      {'page': HomeScreen(), 'title': getTranslated(context, 'notifications')},
      {'page': SearchScreen(), 'title': getTranslated(context, 'search')},
    ];
    return Scaffold(
      appBar: AppBar(
        title: getTitle(
            title: _pages[_selectedPageIndex]['title'],
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 20),
        backgroundColor: Colors.white,
      ),
      drawer: MainDrawer(),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: CurvedNavigationBar(
        onTap: selectPage,
        backgroundColor: Colors.white,
        color: Theme.of(context).primaryColor,
        buttonBackgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        height: 60,
        letIndexChange: (index) => true,
        items: [
          Icon(Icons.home),
          Icon(Icons.message),
          Icon(Icons.notifications),
          Icon(Icons.search),
        ],
      ),
    );
  }
}
