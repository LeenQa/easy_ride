import 'package:easy_ride/localization/language_constants.dart';
import 'package:flutter/material.dart';

class BecomeDriverScreen extends StatelessWidget {
  static const routeName = '/become_driver';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, 'bcmadriver')),
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: Text("Become Driver"),
      ),
    );
  }
}
