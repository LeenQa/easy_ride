import 'package:easy_ride/models/user.dart';
import 'package:flutter/material.dart';
import 'package:easy_ride/Screens/Signup/components/signup_body.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = "/signup";
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var _isLoading = false;
  final _auth = FirebaseAuth.instance;
  _signUpForm(
    User _user,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });
      AuthResult authResult;
      authResult = await _auth.createUserWithEmailAndPassword(
        email: _user.email,
        password: _user.password,
      );
      await Firestore.instance
          .collection('users')
          .document(authResult.user.uid)
          .setData({
        'firstName': _user.firstName,
        'lastName': _user.lastName,
        'phone': _user.phone,
        'email': _user.email,
      });
    } on PlatformException catch (err) {
      var message = 'An error occured, please check your credentials!';
      if (err.message != null) {
        message = err.message;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingupBody(
        _signUpForm,
        _isLoading,
      ),
    );
  }
}
