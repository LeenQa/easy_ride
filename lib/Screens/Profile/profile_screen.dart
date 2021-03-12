import 'package:easy_ride/localization/language_constants.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, 'profile')),
      ),
      body: Container(
        child: Text("Profile"),
      ),
    );
  }
}
