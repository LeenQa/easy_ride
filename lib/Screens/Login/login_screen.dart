import 'package:easy_ride/Screens/Login/components/login_body.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import '../Signup/components/user.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  _loginForm(
    User user,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });
      AuthResult authResult;
      authResult = await _auth.signInWithEmailAndPassword(
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
      body: LoginBody(_loginForm, _isLoading),
    );
  }
}
