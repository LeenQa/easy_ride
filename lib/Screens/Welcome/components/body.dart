import 'package:flutter/material.dart';
import 'package:easy_ride/Screens/Login/login_screen.dart';
import 'package:easy_ride/Screens/Signup/signup_screen.dart';
import 'package:easy_ride/Screens/Welcome/components/background.dart';
import 'package:easy_ride/components/rounded_button.dart';
import 'package:easy_ride/constants.dart';
import 'package:easy_ride/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../main.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListTile(
              leading: RaisedButton(
                onPressed: () {
                  MyApp.of(context)
                      .setLocale(Locale.fromSubtags(languageCode: 'en'));
                },
                child: Text('ENGLISH'),
              ),
              trailing: RaisedButton(
                onPressed: () {
                  MyApp.of(context)
                      .setLocale(Locale.fromSubtags(languageCode: 'ar'));
                },
                child: Text('ARABIC'),
              ),
            ),
            Text(
              AppLocalizations.of(context).helloWorld,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.05),
            ClipRRect(
              child: Image.asset(
                "assets/icons/EZ.png",
                height: size.height * 0.35,
              ),
              borderRadius: BorderRadius.circular(120),
            ),
            SizedBox(height: size.height * 0.05),
            RoundedButton(
              text: "LOGIN",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
            RoundedButton(
              text: "SIGN UP",
              color: kPrimaryDarkColor,
              textColor: Colors.white,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
