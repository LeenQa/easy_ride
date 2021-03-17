import 'package:easy_ride/localization/language_constants.dart';
import 'package:flutter/material.dart';
import 'package:easy_ride/Screens/Login/login_screen.dart';
import 'package:easy_ride/Screens/Signup/signup_screen.dart';
import 'package:easy_ride/Screens/Welcome/components/background.dart';
import 'package:easy_ride/components/rounded_button.dart';
import 'package:easy_ride/constants.dart';

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
            Text(
              getTranslated(context, 'welcome'),
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            Text(
              "EasyRide",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor),
            ),
            SizedBox(height: size.height * 0.05),
            ClipRRect(
              child: Image.asset(
                "assets/icons/EZ.png",
                height: size.height * 0.25,
              ),
              borderRadius: BorderRadius.circular(120),
            ),
            SizedBox(height: size.height * 0.05),
            RoundedButton(
              text: getTranslated(context, 'login'),
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
              text: getTranslated(context, 'signup'),
              color: kSecondaryColor,
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
