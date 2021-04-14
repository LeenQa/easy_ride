import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/models/user.dart' as User;
import 'package:flutter/material.dart';
import 'package:easy_ride/Screens/Signup/components/signup_body.dart';
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
    User.User _user,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });

      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
        email: _user.email,
        password: _user.password,
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authResult.user.uid)
          .set({
        'firstName': _user.firstName,
        'lastName': _user.lastName,
        'phone': _user.phone,
        'email': _user.email,
        'urlAvatar':
            "https://firebasestorage.googleapis.com/v0/b/easyride-8fdc3.appspot.com/o/profilepics%2Fuser.png?alt=media&token=089e3870-577e-4339-a79e-1489d54db07e",
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
