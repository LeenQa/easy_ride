import 'package:easy_ride/localization/language_constants.dart';
import 'package:flutter/material.dart';

class UserSearchScreen extends StatelessWidget {
  static const routeName = '/user_search';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, 'srchforausr')),
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: Text("User Search"),
      ),
    );
  }
}
