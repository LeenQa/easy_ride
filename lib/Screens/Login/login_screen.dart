import 'package:easy_ride/Screens/Admin_Panel/admin_panel_screen.dart';
import 'package:easy_ride/Screens/Login/components/login_body.dart';
import 'package:easy_ride/Screens/tabs_screen.dart';
import 'package:easy_ride/components/main_drawer.dart';
import 'package:easy_ride/models/user.dart' as User;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "/login";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  var message = "";
  bool _isLoading = false;
  _loginForm(
    User.User user,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });
      UserCredential authResult;
      authResult = await _auth
          .signInWithEmailAndPassword(
        email: user.email,
        password: user.password,
      )
          .then((value) {
        if (value.user.uid.startsWith("CjaDPZMqhpQD9j4rs33tqhROVS63")) {
          Navigator.pushReplacementNamed(context, AdminPanelScreen.routeName);
        } else {
          Navigator.pushReplacementNamed(context, TabsScreen.routeName);
        }
      });
    } on PlatformException catch (err) {
      message = 'An error occured, please check your credentials!';
      if (err.message != null) {
        message = err.message;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: getTitle(title: message),
        backgroundColor: Theme.of(context).errorColor,
      ));
      if (this.mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (err) {
      print(err);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: getTitle(title: err.toString().substring(30)),
        backgroundColor: Theme.of(context).errorColor,
      ));
      if (this.mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginBody(_loginForm, _isLoading),
    );
  }
}
