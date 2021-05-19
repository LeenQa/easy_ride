import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/Screens/Profile/profile_screen.dart';
import 'package:easy_ride/components/custom_elevated_button.dart';
import 'package:easy_ride/components/rounded_input_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:easy_ride/constants.dart';
import 'package:easy_ride/components/main_drawer.dart';
import 'package:easy_ride/components/return_message.dart';
import 'package:easy_ride/localization/language_constants.dart';
import 'package:easy_ride/Screens/Signup/components/field_validation.dart';

class ProfilePicScreen extends StatefulWidget {
  static const String routeName = '/editprofilescreen';

  @override
  _ProfilePicScreenState createState() => _ProfilePicScreenState();
}

class _ProfilePicScreenState extends State<ProfilePicScreen> {
  File _image;
  final picker = ImagePicker();
  String _uploadedFileURL;
  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _textFieldController2 = TextEditingController();
  final _formKeyPhone = GlobalKey<FormState>();
  final _formKeyName = GlobalKey<FormState>();
  final _formKeyPassword = GlobalKey<FormState>();
  String currValidatorResponse = null;
  String newValidatorResponse = null;

  String valid() {
    Map args = ModalRoute.of(context).settings.arguments;
    if (_textFieldController.text.trim() == "" ||
        _textFieldController.text == null ||
        _textFieldController2.text.trim() == "" ||
        _textFieldController2.text == null) {
      return "please provide a value";
    } else
      return null;
  }

  Future<String> validPass() async {
    Map args = ModalRoute.of(context).settings.arguments;
    if (_textFieldController.text.trim() == "" ||
        _textFieldController.text == null ||
        _textFieldController2.text.trim() == "" ||
        _textFieldController2.text == null) {
      if (_textFieldController.text.trim() == "" ||
          _textFieldController.text == null) {
        setState(() {
          currValidatorResponse = "please provide a value";
        });
      }
      if (_textFieldController2.text.trim() == "" ||
          _textFieldController2.text == null) {
        setState(() {
          newValidatorResponse = "please provide a value";
        });
      }
    } else {
      String valid =
          FieldValidation.validatePassword(_textFieldController2.text, context);
      if (valid == null) {
        var message;
        var user = await FirebaseFirestore.instance
            .collection("users")
            .doc(args["id"])
            .get();
        String email = user.data()["email"];
        try {
          final curruser = (await FirebaseAuth.instance
                  .signInWithEmailAndPassword(
                      email: email, password: _textFieldController.text))
              .user;

          await curruser.updatePassword(_textFieldController2.text);
          message = 'true';
        } on PlatformException catch (err) {
          message = 'An error occurred, pelase check your credentials!';
          if (err.message != null) {
            message = err.message;
          }
        } on FirebaseException catch (err) {
          message = err.code;
        }
        if (message == 'wrong-password') {
          setState(() {
            currValidatorResponse =
                'make sure to write the current password correctly';
          });
        } else if (message == 'true') {
          setState(() {
            currValidatorResponse = null;
            newValidatorResponse = null;
          });
        } else {
          setState(() {
            newValidatorResponse = message;
          });
        }
      } else
        setState(() {
          newValidatorResponse =
              "Make sure your password contains numbers, special characters & capital letter";
        });
    }
  }

  Future<void> _changePhoneDialog(BuildContext context, String text) async {
    Map args = ModalRoute.of(context).settings.arguments;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: getTitle(title: text),
          content: Form(
            key: _formKeyPhone,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: _textFieldController,
                    validator: (value) {
                      if (value == null) {
                        return "please provide a value";
                      } else
                        return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: getTitle(title: 'Cancel', color: kPrimaryColor),
              onPressed: () {
                _textFieldController.text = "";
                Navigator.pop(context);
              },
            ),
            FlatButton(
                child: getTitle(title: 'Change', color: kPrimaryColor),
                onPressed: () async {
                  final isValid = _formKeyPhone.currentState.validate();
                  if (isValid) {
                    await FirebaseFirestore.instance
                        .collection("users")
                        .doc(args["id"])
                        .update({"phone": _textFieldController.text});
                    _textFieldController.text = "";
                    Navigator.pop(context);
                  }
                }),
          ],
        );
      },
    );
  }

  Future<void> _changeNameDialog(BuildContext context, String text) async {
    Map args = ModalRoute.of(context).settings.arguments;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: getTitle(title: text),
          content: Container(
            height: 150,
            child: Form(
              key: _formKeyName,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null) {
                          return "please provide a value";
                        } else
                          return null;
                      },
                      controller: _textFieldController,
                      decoration: InputDecoration(hintText: "first name"),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null) {
                          return "please provide a value";
                        } else
                          return null;
                        ;
                      },
                      controller: _textFieldController2,
                      decoration: InputDecoration(hintText: "last name"),
                    )
                  ],
                ),
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: getTitle(title: 'Cancel', color: kPrimaryColor),
              onPressed: () {
                _textFieldController.text = "";
                _textFieldController2.text = "";
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: getTitle(title: 'Change', color: kPrimaryColor),
              onPressed: () async {
                final isValid = _formKeyName.currentState.validate();
                if (isValid) {
                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(args["id"])
                      .update({"firstName": _textFieldController.text});
                  _textFieldController.text = "";
                  Navigator.pop(context);
                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(args["id"])
                      .update({"lastName": _textFieldController2.text});
                  _textFieldController2.text = "";
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _currPass(BuildContext context, String text) async {
    Map args = ModalRoute.of(context).settings.arguments;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: getTitle(title: text),
          content: Container(
            height: 150,
            child: Form(
              key: _formKeyPassword,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        return currValidatorResponse;
                      },
                      controller: _textFieldController,
                      decoration: InputDecoration(
                          hintText: "write your current password"),
                    ),
                    TextFormField(
                      validator: (value) {
                        return newValidatorResponse;
                      },
                      controller: _textFieldController2,
                      decoration:
                          InputDecoration(hintText: "write a new password"),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: getTitle(title: 'Cancel', color: kPrimaryColor),
              onPressed: () {
                _textFieldController.text = "";
                _textFieldController2.text = "";
                currValidatorResponse = null;
                newValidatorResponse = null;
                Navigator.pop(context);
              },
            ),
            FlatButton(
                child: getTitle(title: 'Ok', color: kPrimaryColor),
                onPressed: () async {
                  validPass();
                  final isValid = _formKeyPassword.currentState.validate();
                  if (isValid) {
                    ReturnMessage.success(context, 'password updated');
                    _textFieldController.text = "";
                    _textFieldController2.text = "";
                    currValidatorResponse = null;
                    newValidatorResponse = null;
                    Navigator.pop(context);
                  }
                }),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: getTitle(
              title: getTranslated(context, 'profile'),
              color: kPrimaryColor,
              fontSize: 20),
        ),
        body: Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomElevatedButton(
                onPressed: () {
                  _showSelectionDialog();
                },
                title: 'Change profile photo',
                color: Colors.white,
              ),
              SizedBox(height: 20),
              CustomElevatedButton(
                title: "Change full name",
                color: Colors.white,
                onPressed: () => _changeNameDialog(context, "type a new name"),
              ),
              SizedBox(height: 20),
              CustomElevatedButton(
                title: "Change phone number",
                color: Colors.white,
                onPressed: () =>
                    _changePhoneDialog(context, "type a new phone number"),
              ),
              SizedBox(height: 20),
              CustomElevatedButton(
                title: "Change password",
                color: Colors.white,
                onPressed: () => _currPass(context, "type a new password"),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future selectOrTakePhoto(ImageSource imageSource) async {
    final pickedFile = await picker.getImage(source: imageSource);
    Map args = ModalRoute.of(context).settings.arguments;
    setState(() async {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        Reference storageReference;
        storageReference = FirebaseStorage.instance
            .ref()
            .child('profilepics/${Path.basename(_image.path)}');
        UploadTask uploadTask = storageReference.putFile(File(_image.path));
        await uploadTask.whenComplete(() {
          print('File Uploaded');
          print(args["id"]);
          storageReference.getDownloadURL().then((fileURL) async {
            _uploadedFileURL = fileURL;
            print(fileURL);
            await FirebaseFirestore.instance
                .collection('users')
                .doc(args["id"])
                .update({
              'urlAvatar': _uploadedFileURL,
            });
            Navigator.pushNamed(context, ProfileScreen.routeName);
          });
        });
      } else
        print('No photo was selected or taken');
    });
  }

  Future _showSelectionDialog() async {
    await showDialog(
      builder: (context) => SimpleDialog(
        title: Text('Select photo'),
        children: <Widget>[
          SimpleDialogOption(
            child: Text('From gallery'),
            onPressed: () {
              selectOrTakePhoto(ImageSource.gallery);
              Navigator.pop(context);
            },
          ),
          SimpleDialogOption(
            child: Text('Take a photo'),
            onPressed: () {
              selectOrTakePhoto(ImageSource.camera);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      context: context,
    );
  }
}
