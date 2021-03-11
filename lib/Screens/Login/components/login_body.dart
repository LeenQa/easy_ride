import 'package:easy_ride/Screens/tabs_screen.dart';
import 'package:easy_ride/constants.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:flutter/material.dart';
import 'package:easy_ride/Screens/Login/components/background.dart';
import 'package:easy_ride/Screens/Signup/signup_screen.dart';
import 'package:easy_ride/components/already_have_an_account_acheck.dart';
import 'package:easy_ride/components/rounded_button.dart';
import 'package:easy_ride/components/rounded_input_field.dart';
import 'package:easy_ride/components/rounded_password_field.dart';
import '../../Signup/components/user.dart';

class LoginBody extends StatefulWidget {
  final void Function(
    User user,
  ) loginSubmit;
  final bool _isLoading;
  LoginBody(this.loginSubmit, this._isLoading);

  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  User _user = User();
  final _formKey = GlobalKey<FormState>();

  void _trySubmit(BuildContext ctx) {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      widget.loginSubmit(_user);
      Navigator.of(ctx).pushNamed(TabsScreen.routeName, arguments: {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _user = User();
    return Background(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                getTranslated(context, 'login'),
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              ClipRRect(
                child: Image.asset(
                  "assets/icons/EZ.png",
                  height: size.height * 0.25,
                ),
                borderRadius: BorderRadius.circular(120),
              ),
              SizedBox(height: size.height * 0.03),
              RoundedInputField(
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                hintText: getTranslated(context, 'email'),
                onSaved: (value) {
                  _user.email = value.trim();
                },
              ),
              RoundedPasswordField(
                hintText: getTranslated(context, 'password'),
                validator: (value) {
                  if (value.isEmpty) {
                    return getTranslated(context, 'fillemptyfields');
                  } else
                    return null;
                },
                onSaved: (value) {
                  _user.password = value.trim();
                },
              ),
              if (widget._isLoading)
                CircularProgressIndicator(
                  backgroundColor: kPrimaryColor,
                ),
              if (!widget._isLoading)
                RoundedButton(
                  text: getTranslated(context, 'login'),
                  press: () => _trySubmit(context),
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
      ),
    );
  }
}
