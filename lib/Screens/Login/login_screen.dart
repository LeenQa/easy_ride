import 'package:easy_ride/Screens/Admin_Panel/admin_panel_screen.dart';
import 'package:easy_ride/Screens/Login/components/login_body.dart';
import 'package:easy_ride/Screens/tabs_screen.dart';
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
  bool _isLoading = false;
  _loginForm(
    User.User user,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });
      UserCredential authResult;
      authResult = await _auth.signInWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      if (authResult.user.uid.startsWith("fjsrQq4AmdVWHK8Z7vSHlFRelBV2")) {
        Navigator.pushReplacementNamed(context, AdminPanelScreen.routeName);
      }
      //  if (authResult.user.emailVerified) {
      Navigator.pushReplacementNamed(context, TabsScreen.routeName);
      // } else {
      //   Navigator.pushNamed(context, EmailConfirmationScreen.routeName);
      // }
    } on PlatformException catch (err) {
      var message = 'An error occured, please check your credentials!';
      if (err.message != null) {
        message = err.message;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));
      if (this.mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (err) {
      print(err);
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
