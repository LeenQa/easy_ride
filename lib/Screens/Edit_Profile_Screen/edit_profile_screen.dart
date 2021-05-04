import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride/Screens/Profile/profile_screen.dart';
import 'package:easy_ride/components/custom_elevated_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:easy_ride/constants.dart';
import 'package:easy_ride/components/main_drawer.dart';
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

  Future<void> _changePhoneDialog(BuildContext context, String text) async {
    Map args = ModalRoute.of(context).settings.arguments;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: getTitle(title: text),
          content: TextField(
            controller: _textFieldController,
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
                if (_textFieldController.text.trim() != "" &&
                    _textFieldController.text != null) {
                  if (text.toLowerCase().contains("phone")) {
                    var phone = int.tryParse(_textFieldController.text);
                    if (phone == null) {
                      print("NAN");
                    } else {
                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(args["id"])
                          .update({"phone": _textFieldController.text});
                      _textFieldController.text = "";
                      Navigator.pop(context);
                    }
                  }
                } else
                  print("please provide a value");
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _changeNameOrPassDialog(
      BuildContext context, String text, bool pass) async {
    Map args = ModalRoute.of(context).settings.arguments;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: getTitle(title: text),
          content: pass
              ? Container(
                  height: 100,
                  child: Column(
                    children: [
                      TextField(
                        controller: _textFieldController,
                        decoration:
                            InputDecoration(hintText: "current password"),
                      ),
                      TextField(
                        controller: _textFieldController2,
                        decoration: InputDecoration(hintText: "new password"),
                      )
                    ],
                  ),
                )
              : Container(
                  height: 100,
                  child: Column(
                    children: [
                      TextField(
                        controller: _textFieldController,
                        decoration: InputDecoration(hintText: "first name"),
                      ),
                      TextField(
                        controller: _textFieldController2,
                        decoration: InputDecoration(hintText: "last name"),
                      )
                    ],
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
                if (_textFieldController.text.trim() != "" &&
                    _textFieldController.text != null &&
                    _textFieldController2.text.trim() != "" &&
                    _textFieldController2.text != null) {
                  if (text.toLowerCase().contains("password")) {
                    String valid = FieldValidation.validatePassword(
                        _textFieldController.text, context);
                    if (valid == null) {
                      final auth = FirebaseAuth.instance.currentUser;

                      auth.updatePassword(_textFieldController.text);
                      _textFieldController.text = "";
                      Navigator.pop(context);
                    } else {
                      print(valid);
                    }
                  } else if (text.toLowerCase().contains("name")) {
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
                } else
                  print("please provide a value");
              },
            ),
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

                //   child: Container(
                //     height: 150,
                //     width: 150,
                //     child: _image == null
                //         ? Image.asset(
                //             'assets/images/user.png') // set a placeholder image when no photo is set
                //         : Image.file(_image),
                //   ),
                // ),
                // SizedBox(height: 50),
                title: 'Change profile photo',
              ),
              SizedBox(height: 20),
              CustomElevatedButton(
                title: "Change full name",
                onPressed: () =>
                    _changeNameOrPassDialog(context, "type a new name", false),
              ),
              SizedBox(height: 20),
              // CustomElevatedButton(
              //   title: "Change last name",
              //   onPressed: () =>
              //       _displayTextInputDialog(context, "type a new last name"),
              // ),
              // SizedBox(height: 20),
              CustomElevatedButton(
                title: "Change phone number",
                onPressed: () =>
                    _changePhoneDialog(context, "type a new phone number"),
              ),
              SizedBox(height: 20),
              CustomElevatedButton(
                title: "Change password",
                onPressed: () => _changeNameOrPassDialog(
                    context, "type a new password", true),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// Method for sending a selected or taken photo to the EditPage
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

  /// Selection dialog that prompts the user to select an existing photo or take a new one
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
