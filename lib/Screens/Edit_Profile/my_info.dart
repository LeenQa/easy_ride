import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/components/main_drawer.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:easy_ride/text_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants.dart';

class MyInfo extends StatefulWidget {
  final String name;
  final String urlAvatar;

  MyInfo(this.name, this.urlAvatar);

  @override
  _MyInfoState createState() => _MyInfoState();
}

class _MyInfoState extends State<MyInfo> {
  double sizedBoxSize = 10;

  final ifDriverS = 20;

  File _image;

  final picker = ImagePicker();

  String _uploadedFileURL;

  TextEditingController _textFieldControllerName = TextEditingController();
  TextEditingController _textFieldController2 = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  String uid;
  DocumentSnapshot user;
  String userName;

  getUser() async {
    Map args = ModalRoute.of(context).settings.arguments;
    uid = auth.currentUser.uid;
    user = await FirebaseFirestore.instance.collection("users").doc(uid).get();
    // user.data()["firstName"]
  }

  @override
  Widget build(BuildContext context) {
    _textFieldControllerName.text = widget.name;
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                border: Border.all(
                  width: 3,
                  color: kPrimaryColor,
                ),
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(widget.urlAvatar),
                  fit: BoxFit.fitWidth,
                )),
          ),
          SizedBox(
            height: sizedBoxSize,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _textFieldControllerName,
              ),
            ],
          ),
          //if driver display this
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.verified_rounded,
                color: Colors.blue,
                size: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: getTitle(
                    title: getTranslated(context, 'verifieddriver'),
                    color: Colors.blue[400]),
              )
            ],
          ),
        ],
      ),
    );
  }
}
