import 'package:easy_ride/Screens/Signup/components/field_validation.dart';
import 'package:easy_ride/Screens/Signup/components/user.dart';
import 'package:easy_ride/Screens/tabs_screen.dart';
import 'package:easy_ride/components/rounded_input_field.dart';
import 'package:easy_ride/components/rounded_password_field.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:flutter/material.dart';
import 'package:easy_ride/Screens/Login/login_screen.dart';
import 'package:easy_ride/Screens/Signup/components/background.dart';
import 'package:easy_ride/Screens/Signup/components/or_divider.dart';
import 'package:easy_ride/Screens/Signup/components/social_icon.dart';
import 'package:easy_ride/components/already_have_an_account_acheck.dart';
import 'package:easy_ride/components/rounded_button.dart';
import '../../../constants.dart';

class SingupBody extends StatefulWidget {
  final void Function(
    User user,
  ) signupSubmit;
  final bool _isLoading;
  SingupBody(this.signupSubmit, this._isLoading);
  @override
  _SingupBodyState createState() => _SingupBodyState();
}

class _SingupBodyState extends State<SingupBody> {
  User _user = User();
  final _formKey = GlobalKey<FormState>();

  void _trySubmit(BuildContext ctx) {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      widget.signupSubmit(_user);
      Navigator.of(ctx).pushNamed(
        LoginScreen.routeName,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String _passConf = '';
    _user = User();
    return Background(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: size.height * 0.07),
              Text(
                getTranslated(context, 'signup'),
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(height: size.height * 0.03),
              ClipRRect(
                child: Image.asset(
                  "assets/icons/EZ.png",
                  height: size.height * 0.2,
                ),
                borderRadius: BorderRadius.circular(120),
              ),
              SizedBox(height: size.height * 0.02),
              RoundedInputField(
                icon: Icons.person,
                hintText: getTranslated(context, 'firstname'),
                onSaved: (value) {
                  _user.firstName = value.trim();
                },
              ),
              RoundedInputField(
                icon: Icons.person,
                hintText: getTranslated(context, 'lastname'),
                onSaved: (value) {
                  _user.lastName = value.trim();
                },
              ),
              RoundedInputField(
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                hintText: getTranslated(context, 'email'),
                onSaved: (value) {
                  _user.email = value.trim();
                },
              ),
              RoundedInputField(
                icon: Icons.person,
                hintText: getTranslated(context, 'username'),
                onSaved: (value) {
                  _user.username = value.trim();
                },
              ),
              RoundedInputField(
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                hintText: getTranslated(context, 'phone'),
                onSaved: (value) {
                  _user.phone = int.parse(value.trim());
                },
              ),
              RoundedPasswordField(
                hintText: getTranslated(context, 'password'),
                validator: (value) {
                  var check = FieldValidation.validatePassword(value, context);
                  if (check == null) {
                    _passConf = value;
                  }
                  return check;
                },
                onSaved: (value) {
                  _user.password = value.trim();
                },
              ),
              RoundedPasswordField(
                hintText: getTranslated(context, 'confirmpass'),
                validator: (value) {
                  if (value.isEmpty) {
                    return getTranslated(context, 'fillemptyfields');
                  } else if (_passConf != value) {
                    return getTranslated(context, 'passwordsnotmatch');
                  } else
                    return null;
                },
                onSaved: (value) => _passConf = value,
              ),
              if (widget._isLoading)
                CircularProgressIndicator(
                  backgroundColor: kPrimaryColor,
                ),
              if (!widget._isLoading)
                RoundedButton(
                  text: getTranslated(context, 'signup'),
                  press: () => _trySubmit(context),
                ),
              SizedBox(height: size.height * 0.03),
              AlreadyHaveAnAccountCheck(
                login: false,
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
              OrDivider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SocalIcon(
                    iconSrc: "assets/icons/facebook.svg",
                    press: () {},
                  ),
                  SocalIcon(
                    iconSrc: "assets/icons/google-plus.svg",
                    press: () {},
                  ),
                  SizedBox(height: size.height * 0.19),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
