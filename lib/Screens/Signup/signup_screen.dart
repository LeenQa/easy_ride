import 'package:flutter/material.dart';
import 'package:easy_ride/Screens/Signup/components/signup_body.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'components/user.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = FirebaseAuth.instance;
  _signUpForm(
    User user,
  ) async {
    try {
      AuthResult authResult;
      authResult = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
    } on PlatformException catch (err) {
      var message = 'An error occured, please check your credentials!';
      if (err.message != null) {
        message = err.message;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingupBody(_signUpForm),
    );
  }
}
