import 'package:easy_ride/localization/language_constants.dart';
import 'package:easy_ride/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, 'profile')),
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [Text('Testing Providers')],
            ),
            Row(
              children: [Text('Name: ${users.firstName}')],
            )
          ],
        ),
      ),
    );
  }
}
