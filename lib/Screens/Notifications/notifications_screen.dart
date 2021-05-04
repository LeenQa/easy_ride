import 'package:easy_ride/components/main_drawer.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: getTitle(
            title: getTranslated(context, 'profile'),
            color: kPrimaryColor,
            fontSize: 20),
      ),
      body: Container(),
    );
  }
}
