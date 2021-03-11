import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easy_ride/Screens/Home/home_screen.dart';
import 'package:easy_ride/Screens/Messages/messages_screen.dart';
import 'package:easy_ride/Screens/Notifications/notifications_screen.dart';
import 'package:easy_ride/Screens/Search/search_screen.dart';
import 'package:easy_ride/components/main_drawer.dart';
import 'package:flutter/material.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/tabs';
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  final List<Map<String, Object>> _pages = [
    {'page': HomeScreen(), 'title': 'Home'},
    {'page': MessagesScreen(), 'title': 'Messages'},
    {'page': NotificationsScreen(), 'title': 'Notifications'},
    {'page': SearchScreen(), 'title': 'Search'},
  ];

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedPageIndex]['title']),
      ),
      drawer: MainDrawer(),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: CurvedNavigationBar(
        onTap: _selectPage,
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
