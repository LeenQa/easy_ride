import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/components/main_drawer.dart';
import 'package:easy_ride/components/return_message.dart';
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
  List<String> searchIndex(String firstname, String lastname) {
    List<String> indexList = [];
    String name = firstname + " " + lastname;

    for (int i = 1; i <= name.length; i++) {
      if (i <= firstname.length) {
        indexList.add(firstname.substring(0, i).toLowerCase());
      }
      if (i <= lastname.length) {
        indexList.add(lastname.substring(0, i).toLowerCase());
      }
      if (i > firstname.length - 1) {
        indexList.add(name.substring(0, i).toLowerCase());
      }
    }
    return indexList;
  }

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
        'location': _user.location,
        'searchIndex': searchIndex(_user.firstName, _user.lastName),
        'token': '',
        'isDriver': false,
        'getChatNotifications': true,
        'getRequestNotifications': true,
        'showPhone': false,
        'urlAvatar':
            "https://firebasestorage.googleapis.com/v0/b/easyride-8fdc3.appspot.com/o/profilepics%2Fuser.png?alt=media&token=089e3870-577e-4339-a79e-1489d54db07e",
      });
    } on PlatformException catch (err) {
      var message = 'An error occured, please check the provided information!';
      if (err.message != null) {
        message = err.message;
      }
      ReturnMessage.fail(context, message);
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      ReturnMessage.fail(context, err.toString().substring(30));
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
