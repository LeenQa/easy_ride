import 'package:flutter/material.dart';
import 'package:easy_ride/Screens/Login/components/background.dart';
import 'package:easy_ride/Screens/Signup/signup_screen.dart';
import 'package:easy_ride/components/already_have_an_account_acheck.dart';
import 'package:easy_ride/components/rounded_button.dart';
import 'package:easy_ride/components/rounded_input_field.dart';
import 'package:easy_ride/components/rounded_password_field.dart';
import 'package:flutter_svg/svg.dart';

class Body extends StatelessWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            ClipRRect(
              child: Image.asset(
                "assets/icons/EZ.png",
                height: size.height * 0.35,
              ),
              borderRadius: BorderRadius.circular(120),
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {},
            ),
            RoundedPasswordField(
              onChanged: (value) {},
            ),
            RoundedButton(
              text: "LOGIN",
              press: () {},
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
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
