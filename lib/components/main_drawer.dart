import 'package:easy_ride/Screens/Become_Driver/become_driver_screen.dart';
import 'package:easy_ride/Screens/Offer_Ride/offer_ride_screen.dart';
import 'package:easy_ride/Screens/Profile/profile_screen.dart';
import 'package:easy_ride/Screens/Settings/settings_screen.dart';
import 'package:easy_ride/Screens/User_Search/user_search_screen.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  Widget buildListTile(
      BuildContext context, String title, IconData icon, Function tabHandler) {
    return ListTile(
      leading: Icon(
        icon,
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
                color: Theme.of(context).accentColor,
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
            'Profile',
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
            'Search for a user',
            Icons.person_search_outlined,
            () {
              Navigator.of(context).pushNamed(UserSearchScreen.routeName);
            },
          ),
          buildListTile(
            context,
            'Offer a ride',
            Icons.add_circle_outline_outlined,
            () {
              Navigator.of(context).pushNamed(OfferRideScreen.routeName);
            },
          ),
          buildListTile(
            context,
            'Become a driver',
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
            'Settings',
            Icons.settings,
            () {
              Navigator.of(context).pushNamed(SettingsScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
