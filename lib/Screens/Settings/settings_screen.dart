import 'package:easy_ride/localization/language_constants.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, 'settings')),
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: Text("Settings"),
      ),
    );
  }
}
