import 'package:easy_ride/components/main_drawer.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:flutter/material.dart';
import 'package:easy_ride/constants.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final Function press;
  const AlreadyHaveAnAccountCheck({
    Key key,
    this.login = true,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        getTitle(
            title: login
                ? getTranslated(context, 'noaccount')
                : getTranslated(context, 'haveaccount'),
            color: blueColor),
        GestureDetector(
          onTap: press,
          child: getTitle(
            title: login
                ? getTranslated(context, 'signup')
                : getTranslated(context, 'login'),
            color: blueColor,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
